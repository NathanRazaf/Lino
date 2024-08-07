import mongoose from "mongoose";

const requestSchema = new mongoose.Schema({
    username: { type : String, required : true },
    bookTitle: { type : String, required : true },
    timestamp: { type : Date, default : Date.now },
    customMessage: { type : String},
});

const Request = mongoose.model('Request', requestSchema, "requests");

export default Request;