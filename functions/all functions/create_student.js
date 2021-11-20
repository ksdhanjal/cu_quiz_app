const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors")({origin: true, allowedHeaders: "*"});

exports.createStudent = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    const data = req.body.data;
    const studentData = {...data, semester: parseInt(req.body.data.semester)};
    try {
      db.collection("students")
          .where("uid", "==", studentData.uid)
          .get()
          .then((snapshot) => {
            if (snapshot.empty) {
              db.collection("students").add(studentData);
              res.send({
                data: {
                  message: "Student created successfully",
                  success: true,
                },
              });
            } else {
              res.send({
                data: {
                  message: "Student already exists",
                  success: false,
                },
              });
            }
          });
    } catch (err) {
      res.send({
        data: {
          message: "Error creating student, Please Try again!",
          success: false,
        },
      });
    }
  });
});
