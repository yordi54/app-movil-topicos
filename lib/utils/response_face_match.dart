// To parse this JSON data, do
//
//     final responseFaceMatch = responseFaceMatchFromJson(jsonString);

import 'dart:convert';

ResponseFaceMatch responseFaceMatchFromJson(String str) => ResponseFaceMatch.fromJson(json.decode(str));

String responseFaceMatchToJson(ResponseFaceMatch data) => json.encode(data.toJson());

class ResponseFaceMatch {
    Succeeded succeeded;

    ResponseFaceMatch({
        required this.succeeded,
    });

    factory ResponseFaceMatch.fromJson(Map<String, dynamic> json) => ResponseFaceMatch(
        succeeded: Succeeded.fromJson(json["Succeeded"]),
    );

    Map<String, dynamic> toJson() => {
        "Succeeded": succeeded.toJson(),
    };
}

class Succeeded {
    int transactionStatus;
    String txnId;
    String statusMessage;
    DateTime requestTimestamp;
    DateTime responseTimestamp;
    String refId;
    dynamic data;

    Succeeded({
        required this.transactionStatus,
        required this.txnId,
        required this.statusMessage,
        required this.requestTimestamp,
        required this.responseTimestamp,
        required this.refId,
        required this.data,
    });

    factory Succeeded.fromJson(Map<String, dynamic> json) => Succeeded(
        transactionStatus: json["transaction_status"],
        txnId: json["txn_id"],
        statusMessage: json["statusMessage"],
        requestTimestamp: DateTime.parse(json["request_timestamp"]),
        responseTimestamp: DateTime.parse(json["response_timestamp"]),
        refId: json["ref_Id"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_status": transactionStatus,
        "txn_id": txnId,
        "statusMessage": statusMessage,
        "request_timestamp": requestTimestamp.toIso8601String(),
        "response_timestamp": responseTimestamp.toIso8601String(),
        "ref_Id": refId,
        "data": data,
    };
}


