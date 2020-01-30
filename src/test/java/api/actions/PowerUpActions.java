package api.actions;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.http.Method;
import io.restassured.specification.RequestSpecification;

import static io.restassured.RestAssured.given;

public class PowerUpActions {

    public void enableCustomFieldPowerUp(String idBoard) {
        RestAssured.baseURI = "https://api.trello.com/1";
        RequestSpecification requestSpecification = given()
                .contentType(ContentType.TEXT)
                .queryParam("idPlugin", "56d5e249a98895a9797bebb9")
                .queryParam("key", System.getenv("trl_key"))
                .queryParam("token", System.getenv("trl_token"));
        requestSpecification.request(Method.POST, "/boards/" + idBoard + "/boardPlugins");
    }

}