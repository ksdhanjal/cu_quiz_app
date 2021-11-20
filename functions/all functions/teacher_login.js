const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors")({origin: true});

exports.teacherLogin = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    console.log("login function called");

    const email = request.body.data.email;
    const pass = request.body.data.pass;
    console.log("password passed is", pass);

    try {
      db.collection("teachers")
          .where("email", "==", email)
          .get()
          .then((snapshot) => {
            console.log(snapshot.docs[0].data());
            if (snapshot.empty) {
              console.log("No matching documents.");
              response.send({
                data: {
                  status: "Failed",
                  message: "No users found!",
                  responseCode: 0,
                },
              });
            } else {
              snapshot.forEach((doc) => {
                if (doc.data().pass == pass) {
                  console.log("user found");
                  response.send({
                    data: {
                      status: "Success",
                      message: "Login successfull!",
                      userID: doc.id,
                      responseCode: 1,
                      userName: doc.data().name,
                    },
                  });
                } else {
                  console.log("wrong password!");
                  response.send({
                    data: {
                      status: "Failed",
                      message: "Wrong password!",
                      responseCode: 2,
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
          responseCode: 3,
        },
      });
    }
  });
});
