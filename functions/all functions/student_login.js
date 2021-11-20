const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors")({origin: true});

exports.login = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    console.log("login function called");

    const uid = request.body.data.uid;
    const phone = request.body.data.phone;

    try {
      db.collection("students")
          .where("uid", "==", uid)
          .get()
          .then((snapshot) => {
            if (snapshot.empty) {
              console.log("No matching documents.");
              response.send({
                data: {
                  status: "Failed",
                  message: "No users found!",
                  response_code: 0,
                },
              });
            } else {
              snapshot.forEach((doc) => {
                if (doc.data().phone == phone) {
                  console.log("user found");
                  response.send({
                    data: {
                      status: "Success",
                      message: "Login successfull!",
                      userID: doc.id,
                      response_code: 1,
                    },
                  });
                } else {
                  console.log("wrong phone");
                  response.send({
                    data: {
                      status: "Failed",
                      message: "Wrong phone number!",
                      response_code: 2,
                    },
                  });
                }
              });
            }
          });
    } catch (err) {
      console.log(err);
      response.send({
        data: {
          status: "Failed",
          message: err.message,
          response_code: 3,
        },
      });
    }
  });
});
