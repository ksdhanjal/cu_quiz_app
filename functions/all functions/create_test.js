const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors")({origin: true, allowedHeaders: "*"});

exports.createTest = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    const testData = req.body.data;
    db.collection("tests")
        .add(testData)
        .then(() => {
          res.send({
            data: {success: true, message: "Test Published Successfully!"},
          });
        })
        .catch((err) => {
          res.send({data: {success: false, message: err.message}});
        });
  });
});
