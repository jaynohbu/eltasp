// Before working with this sample code, please be sure to read the accompanying Readme.txt file.
// It contains important information regarding the appropriate use of and conditions for this
// sample code. Also, please pay particular attention to the comments included in each individual
// code file, as they will assist you in the unique and correct implementation of this code on
// your specific platform.
//
// Copyright 2007 Authorize.Net Corp.


using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Schema;


// These classes are used to serialize and deserialize data sent and received
// from the API server for the Automated Recurring Billing (ARB) API.


namespace AuthorizeNet
{
    public class MerchantAuthentication
    {
        public string name;
        public string transactionKey;
    }

    public class ANetApiRequest
    {
        public MerchantAuthentication merchantAuthentication;
        public string refId = null;
    }

    public class Messages
    {
        public enum MessageType
        {
            Ok, Error
        }
        public MessageType resultCode;
        public class Message
        {
            public string code;
            public string text;
        }

        [System.Xml.Serialization.XmlElementAttribute("message")]
        public Message[] message;
    }

    public enum SubscriptionUnitType
    {
        days, months
    }

    public class NameAndAddress
    {
        public string firstName;
        public string lastName;
        public string company;
        public string address;
        public string city;
        public string state;
        public string zip;
        public string country;
    }

    public class PaymentSchedule
    {
        public struct Interval
        {
            public int length;
            public SubscriptionUnitType unit;
        }
        [System.Xml.Serialization.XmlIgnore()]
        public bool intervalSpecified;
        public Interval interval;

        public string startDate;        // Format is YYYY-MM-DD

        [System.Xml.Serialization.XmlIgnore()]
        public bool totalOccurrencesSpecified;
        public int totalOccurrences;

        [System.Xml.Serialization.XmlIgnore()]
        public bool trialOccurrencesSpecified;
        public int trialOccurrences;
    }

    public class CreditCard
    {
        public string cardNumber;       // Number must be 13 or 16 digits. Must pass LUHN check.
        public string expirationDate;   // Format must be YYYY-MM
        public string cardCode;
    }

    public class BankAccount
    {
        public string accountType;      // One of "checking", "savings", or "businessChecking"
        public string routingNumber;    // Number must be 9 digits
        public string accountNumber;    // Number should be 5 to 17 digits
        public string nameOnAccount;
        public string echeckType;       // One of "PPD", "WEB", "CCD", or "TEL"
        public string bankName;
    }

    public class Payment
    {
        // Choice of BankAccountType or CreditCardType
        [System.Xml.Serialization.XmlElementAttribute("bankAccount", typeof(BankAccount))]
        [System.Xml.Serialization.XmlElementAttribute("creditCard", typeof(CreditCard))]
        public object item;
    }

    public class ARBSubscription
    {
        public string name;
        public PaymentSchedule paymentSchedule;

        [System.Xml.Serialization.XmlIgnore()]
        public bool amountSpecified;
        public decimal amount;

        [System.Xml.Serialization.XmlIgnore()]
        public bool trialAmountSpecified;
        public decimal trialAmount;

        public Payment payment;

        [System.Xml.Serialization.XmlIgnore()]
        public bool orderSpecified;
        public struct order
        {
            public string invoiceNumber;
            public string description;
        }

        [System.Xml.Serialization.XmlIgnore()]
        public bool customerSpecified;
        public struct customer
        {
            public string type;     // Either "individual" or "business"
            public string id;
            public string email;
            public string phoneNumber;
            public string faxNumber;

            [System.Xml.Serialization.XmlIgnore()]
            public bool driversLicenseSpecified;
            public struct driversLicense
            {
                public string number;
                public string state;        // Must be 2 characters
                public string dateOfBirth;  // Format must be YYYY-MM-DD
            }
            public string taxId;
        }

        public NameAndAddress billTo;
        public NameAndAddress shipTo;
    }

    public class ANetApiResponse
    {
        public string refId;
        public Messages messages;
    }

    // --------------------------------------------------------------------------------------------
    // Error
    // --------------------------------------------------------------------------------------------

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ErrorResponse : ANetApiResponse
    {
        // This is the response returned by any API call that cannot get past basic validation
        // of the request. For example, if any errors occur parsing the XML.
        // It does not contain any more data than that provided by ANetApiResponseType.
    }

    // --------------------------------------------------------------------------------------------
    // Create Subscription
    // --------------------------------------------------------------------------------------------

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ARBCreateSubscriptionRequest : ANetApiRequest
    {
        public ARBSubscription subscription;
    }

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ARBCreateSubscriptionResponse : ANetApiResponse
    {
        public string subscriptionId;
    }


    // --------------------------------------------------------------------------------------------
    // Update Subscription
    // --------------------------------------------------------------------------------------------

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ARBUpdateSubscriptionRequest : ANetApiRequest
    {
        public string subscriptionId;
        public ARBSubscription subscription;
    }

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ARBUpdateSubscriptionResponse : ANetApiResponse
    {
        // No extra data returned for the Update method
    }

    // --------------------------------------------------------------------------------------------
    // Cancel Subscription
    // --------------------------------------------------------------------------------------------

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ARBCancelSubscriptionRequest : ANetApiRequest
    {
        public string subscriptionId;
    }

    [System.Serializable]
    [System.Xml.Serialization.XmlRoot(Namespace = "AnetApi/xml/v1/schema/AnetApiSchema.xsd")]
    public class ARBCancelSubscriptionResponse : ANetApiResponse
    {
        // No extra data returned for the Cancel method
    }
}
