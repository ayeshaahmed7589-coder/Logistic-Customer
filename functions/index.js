const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// 1️⃣ TEST FUNCTION
exports.hello = functions.https.onRequest((request, response) => {
  console.log('✅ Hello function called');
  response.json({
    status: 'success',
    message: 'Firebase Functions Working!',
    timestamp: new Date().toISOString()
  });
});

// 2️⃣ ORDER CREATED NOTIFICATION
exports.onOrderCreated = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snapshot, context) => {
    try {
      console.log('📦 [ORDER CREATED FUNCTION TRIGGERED]');
      
      const orderId = context.params.orderId;
      const orderData = snapshot.data();
      const userId = orderData.userId;
      
      console.log('Order ID:', orderId);
      console.log('User ID:', userId);
      
      if (!userId) {
        console.log('❌ No userId found in order');
        return null;
      }
      
      // Get user from Firestore
      const userDoc = await admin.firestore()
        .collection('users')
        .doc(userId)
        .get();
      
      if (!userDoc.exists) {
        console.log('❌ User document does not exist:', userId);
        return null;
      }
      
      const userData = userDoc.data();
      const fcmToken = userData?.fcmToken;
      
      console.log('User Data:', userData);
      console.log('FCM Token:', fcmToken);
      
      if (!fcmToken) {
        console.log('❌ User has no FCM token');
        return null;
      }
      
      // Create notification message
      const message = {
        notification: {
          title: '🎉 New Order Created',
          body: `Your order has been created successfully!`,
        },
        token: fcmToken,
        data: {
          type: 'order_created',
          orderId: orderId,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      
      console.log('📨 Sending notification...');
      
      // Send notification
      const result = await admin.messaging().send(message);
      
      console.log('✅ Notification sent successfully!');
      console.log('Result:', result);
      
      return null;
    } catch (error) {
      console.error('🔥 ERROR in onOrderCreated:', error);
      return null;
    }
  });

// 3️⃣ ORDER STATUS UPDATED NOTIFICATION
exports.onOrderStatusChange = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    try {
      console.log('🔄 [ORDER STATUS UPDATE FUNCTION TRIGGERED]');
      
      const orderId = context.params.orderId;
      const beforeData = change.before.data();
      const afterData = change.after.data();
      
      // Check if status changed
      if (beforeData.status === afterData.status) {
        console.log('   Status unchanged, skipping');
        return null;
      }
      
      console.log('Order ID:', orderId);
      console.log('Old Status:', beforeData.status);
      console.log('New Status:', afterData.status);
      console.log('User ID:', afterData.userId);
      
      if (!afterData.userId) {
        console.log('❌ No userId in order data');
        return null;
      }
      
      // Get user
      const userDoc = await admin.firestore()
        .collection('users')
        .doc(afterData.userId)
        .get();
      
      if (!userDoc.exists) {
        console.log('❌ User not found:', afterData.userId);
        return null;
      }
      
      const userData = userDoc.data();
      const fcmToken = userData?.fcmToken;
      
      if (!fcmToken) {
        console.log('❌ User has no FCM token');
        return null;
      }
      
      // Create status-specific message
      let title = '📦 Order Update';
      let body = '';
      
      switch (afterData.status) {
        case 'assigned':
          title = '🚚 Driver Assigned';
          body = 'A driver has been assigned to your order';
          break;
        case 'picked_up':
          title = '📦 Order Picked Up';
          body = 'Driver has picked up your order';
          break;
        case 'in_transit':
          title = '🚚 Order in Transit';
          body = 'Your order is on the way';
          break;
        case 'delivered':
          title = '🎉 Order Delivered!';
          body = 'Your order has been delivered successfully';
          break;
        case 'cancelled':
          title = '❌ Order Cancelled';
          body = 'Your order has been cancelled';
          break;
        default:
          body = `Order status: ${afterData.status}`;
      }
      
      const message = {
        notification: { title, body },
        token: fcmToken,
        data: {
          type: 'order_status_update',
          orderId: orderId,
          status: afterData.status,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      
      console.log('📨 Sending status notification...');
      await admin.messaging().send(message);
      console.log('✅ Status notification sent!');
      
      return null;
    } catch (error) {
      console.error('🔥 ERROR in onOrderStatusChange:', error);
      return null;
    }
  });

// 4️⃣ PAYMENT STATUS UPDATED NOTIFICATION
exports.onPaymentUpdate = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    try {
      console.log('💳 [PAYMENT UPDATE FUNCTION TRIGGERED]');
      
      const orderId = context.params.orderId;
      const beforeData = change.before.data();
      const afterData = change.after.data();
      
      // Check if payment status changed
      if (beforeData.paymentStatus === afterData.paymentStatus) {
        console.log('   Payment status unchanged, skipping');
        return null;
      }
      
      console.log('Order ID:', orderId);
      console.log('Old Payment:', beforeData.paymentStatus);
      console.log('New Payment:', afterData.paymentStatus);
      
      if (!afterData.userId) {
        return null;
      }
      
      // Get user
      const userDoc = await admin.firestore()
        .collection('users')
        .doc(afterData.userId)
        .get();
      
      if (!userDoc.exists) return null;
      
      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) return null;
      
      // Payment status message
      let title = '💳 Payment Update';
      let body = '';
      
      if (afterData.paymentStatus === 'success') {
        title = '✅ Payment Successful';
        body = 'Your payment was successful!';
      } else if (afterData.paymentStatus === 'failed') {
        title = '❌ Payment Failed';
        body = 'Payment failed. Please try again.';
      } else if (afterData.paymentStatus === 'pending') {
        body = 'Payment is pending';
      }
      
      const message = {
        notification: { title, body },
        token: fcmToken,
        data: {
          type: 'payment_update',
          orderId: orderId,
          paymentStatus: afterData.paymentStatus,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      
      await admin.messaging().send(message);
      console.log('✅ Payment notification sent!');
      
      return null;
    } catch (error) {
      console.error('🔥 ERROR in onPaymentUpdate:', error);
      return null;
    }
  });
// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

// // 1️⃣ ORDER CREATE Notification
// exports.onOrderCreated = functions.firestore
//     .document("orders/{orderId}")
//     .onCreate(async (snapshot, context) => {
//       try {
//         const orderData = snapshot.data();
//         const userId = orderData.userId;

//         // User ka data fetch karein
//         const userDoc = await admin.firestore()
//             .collection("users")
//             .doc(userId)
//             .get();

//         if (!userDoc.exists || !userDoc.data().fcmToken) {
//           console.log("User ya FCM token nahi mila");
//           return null;
//         }

//         const fcmToken = userDoc.data().fcmToken;

//         // Notification message create karein
//         const message = {
//           notification: {
//             title: "🎉 Order Created",
//             body: `Your order #${orderData.orderNumber} has been created successfully!`,
//           },
//           token: fcmToken,
//           data: {
//             type: "order_created",
//             orderId: context.params.orderId,
//             status: "created",
//           },
//         };

//         // Send notification
//         await admin.messaging().send(message);
//         console.log("Order creation notification sent to:", userId);
//         return null;
//       } catch (error) {
//         console.error("Error in order creation notification:", error);
//         return null;
//       }
//     });

// // 2️⃣ ORDER STATUS CHANGE Notification
// exports.onOrderStatusChange = functions.firestore
//     .document("orders/{orderId}")
//     .onUpdate(async (change, context) => {
//       try {
//         const before = change.before.data();
//         const after = change.after.data();

//         // Agar status change nahi hua to return
//         if (before.status === after.status) return null;

//         const userId = after.userId;
//         const orderId = context.params.orderId;

//         // User ka data fetch karein
//         const userDoc = await admin.firestore()
//             .collection("users")
//             .doc(userId)
//             .get();

//         if (!userDoc.exists || !userDoc.data().fcmToken) {
//           console.log("User ya FCM token nahi mila");
//           return null;
//         }

//         const fcmToken = userDoc.data().fcmToken;

//         // Different messages for different statuses
//         let title = "📦 Order Update";
//         let body = "";

//         switch (after.status) {
//           case "assigned":
//             body = `Your order #${after.orderNumber} has been assigned to a driver`;
//             break;
//           case "picked_up":
//             body = `Your order #${after.orderNumber} has been picked up by the driver`;
//             break;
//           case "in_transit":
//             body = `Your order #${after.orderNumber} is in transit`;
//             break;
//           case "delivered":
//             body = `🎊 Your order #${after.orderNumber} has been delivered successfully!`;
//             break;
//           case "cancelled":
//             body = `❌ Your order #${after.orderNumber} has been cancelled`;
//             break;
//           default:
//             body = `Your order #${after.orderNumber} status: ${after.status}`;
//         }

//         // Notification message create karein
//         const message = {
//           notification: {
//             title: title,
//             body: body,
//           },
//           token: fcmToken,
//           data: {
//             type: "order_status",
//             orderId: orderId,
//             status: after.status,
//             previousStatus: before.status,
//           },
//         };

//         // Send notification
//         await admin.messaging().send(message);
//         console.log(`Order status notification sent for ${orderId}: ${after.status}`);
//         return null;
//       } catch (error) {
//         console.error("Error in order status notification:", error);
//         return null;
//       }
//     });

// // 3️⃣ PAYMENT STATUS Notification
// exports.onPaymentUpdate = functions.firestore
//     .document("orders/{orderId}")
//     .onUpdate(async (change, context) => {
//       try {
//         const before = change.before.data();
//         const after = change.after.data();

//         // Agar payment status change nahi hua to return
//         if (before.paymentStatus === after.paymentStatus) return null;

//         const userId = after.userId;
//         const orderId = context.params.orderId;

//         // User ka data fetch karein
//         const userDoc = await admin.firestore()
//             .collection("users")
//             .doc(userId)
//             .get();

//         if (!userDoc.exists || !userDoc.data().fcmToken) {
//           console.log("User ya FCM token nahi mila");
//           return null;
//         }

//         const fcmToken = userDoc.data().fcmToken;

//         // Different messages based on payment status
//         let title = "💳 Payment Update";
//         let body = "";
//         let paymentMethod = after.paymentMethod || "unknown";

//         if (after.paymentStatus === "success") {
//           body = `Payment of ₹${after.amount || "0"} via ${paymentMethod} was successful`;
//         } else if (after.paymentStatus === "failed") {
//           body = `Payment via ${paymentMethod} failed. Please try again`;
//         } else if (after.paymentStatus === "pending") {
//           body = `Payment via ${paymentMethod} is pending`;
//         } else if (after.paymentStatus === "refunded") {
//           body = `Amount refunded to your ${paymentMethod}`;
//         }

//         // Notification message create karein
//         const message = {
//           notification: {
//             title: title,
//             body: body,
//           },
//           token: fcmToken,
//           data: {
//             type: "payment_update",
//             orderId: orderId,
//             paymentStatus: after.paymentStatus,
//             paymentMethod: paymentMethod,
//           },
//         };

//         // Send notification
//         await admin.messaging().send(message);
//         console.log(`Payment notification sent for ${orderId}: ${after.paymentStatus}`);
//         return null;
//       } catch (error) {
//         console.error("Error in payment notification:", error);
//         return null;
//       }
//     });

// // 4️⃣ WALLET TRANSACTION Notification
// exports.onWalletTransaction = functions.firestore
//     .document("walletTransactions/{transactionId}")
//     .onCreate(async (snapshot, context) => {
//       try {
//         const transactionData = snapshot.data();
//         const userId = transactionData.userId;

//         // User ka data fetch karein
//         const userDoc = await admin.firestore()
//             .collection("users")
//             .doc(userId)
//             .get();

//         if (!userDoc.exists || !userDoc.data().fcmToken) {
//           console.log("User ya FCM token nahi mila");
//           return null;
//         }

//         const fcmToken = userDoc.data().fcmToken;

//         let title = "💰 Wallet Update";
//         let body = "";

//         if (transactionData.type === "credit") {
//           body = `₹${transactionData.amount} has been added to your wallet`;
//         } else if (transactionData.type === "debit") {
//           body = `₹${transactionData.amount} has been deducted from your wallet`;
//         }

//         // Notification message create karein
//         const message = {
//           notification: {
//             title: title,
//             body: body,
//           },
//           token: fcmToken,
//           data: {
//             type: "wallet_transaction",
//             transactionId: context.params.transactionId,
//             amount: transactionData.amount.toString(),
//             transactionType: transactionData.type,
//           },
//         };

//         // Send notification
//         await admin.messaging().send(message);
//         console.log("Wallet transaction notification sent");
//         return null;
//       } catch (error) {
//         console.error("Error in wallet transaction notification:", error);
//         return null;
//       }
//     });