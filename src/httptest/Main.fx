package httptest;

import javafx.io.http.HttpHeader;
import javafx.io.http.HttpRequest;
import java.lang.String;
import java.io.*;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.stage.Stage;
import javafx.scene.control.Label;
import java.net.URLDecoder;
import javafx.scene.control.Button;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.animation.transition.RotateTransition;

def testContent: String = "requestEnvelope.errorLanguage=en_US&baseAmountList.currency(0).code=USD&baseAmountList.currency(0).amount=10&convertToCurrencyList.currencyCode(0)=AUD";
var response = "Click to send";

def postRequest: HttpRequest = HttpRequest {

    location: "https://svcs.sandbox.paypal.com/AdaptivePayments/ConvertCurrency";
    method: HttpRequest.POST;
    headers: [
        HttpHeader {
            name: "X-PAYPAL-SECURITY-USERID";
            value: "AdapPa_1267103192_biz_api1.paypal.com";
        },
        HttpHeader {
            name: "X-PAYPAL-SECURITY-PASSWORD";
            value: "1267103201";
        },
        HttpHeader {
            name: "X-PAYPAL-SECURITY-SIGNATURE";
            value: "AprVAF-FylBDbY-nmQAaWr-hL4ewADH0v9LmErPbJICQzMG3CSEZS6kM";
        },
        HttpHeader {
            name: "X-PAYPAL-REQUEST-DATA-FORMAT";
            value: "NV";
        },
        HttpHeader {
            name: "X-PAYPAL-RESPONSE-DATA-FORMAT";
            value: "NV";
        },
        HttpHeader {
            name: "X-PAYPAL-APPLICATION-ID";
            value: "APP-80W284485P519543T";
        }
    ];

    onStarted: function() {
        println("onStarted - started performing method: {postRequest.method} on location: {postRequest.location}");
    }

    onConnecting: function() { println("onConnecting") }
    onOutput: function(os: java.io.OutputStream) {
        try {
            os.write(testContent.getBytes());
        } finally {
            os.close();
        }
    }

    onWritten: function(bytes: Long) { println("onWritten - {bytes} bytes has now been written") }

    onResponseHeaders: function(headerNames: String[]) {
        println("onResponseHeaders - there are {headerNames.size()} response headers:");
        for (name in headerNames) {
            println("    {name}: {postRequest.getResponseHeaderValue(name)}");
        }
    }

    onInput: function(is: InputStream) {
        try {
            var buff = new BufferedReader(new InputStreamReader(is));
            var inputString = new String;

            while((inputString = buff.readLine()) != null)
    		{
    			response = inputString.replaceAll("&","\n");
    		}
            println("{response}");
        } finally {
            is.close();
        }
    }
    onException: function(ex: java.lang.Exception) {
        println("onException - exception: {ex.getClass()} {ex.getMessage()}");
    }
};

var myButton = Button {
	text: "Send API call",
        translateX: 50,
	action: function() {
            transition.play();
            postRequest.start();
	}
}

var sendImage = ImageView {
    image: Image {
        url: "{__DIR__}resources/email.jpg",
        width: 60,
        height: 48,
        }
        translateX: 150,
        translateY: 30,
}

var transition = RotateTransition {
        node: sendImage
        byAngle: 360
        repeatCount: 3
    }
            var stage:Stage = Stage {
            title: "First JavaFX Application"
            scene:Scene {
                   width: 362
                   height: 300
                   content: [
                        myButton,
                        sendImage,
                        Label {
                             translateY: 100,
                             font : Font {size : 16 }
                             text: bind URLDecoder.decode(response, "UTF-8")
                        }
                    ]
            }
        }