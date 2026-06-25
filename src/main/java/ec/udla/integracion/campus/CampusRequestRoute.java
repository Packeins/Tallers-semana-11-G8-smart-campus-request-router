package ec.udla.integracion.campus;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class CampusRequestRoute extends RouteBuilder {
    private final CanonicalRequestTranslator canonicalRequestTranslator;

    public CampusRequestRoute(CanonicalRequestTranslator canonicalRequestTranslator) {
        this.canonicalRequestTranslator = canonicalRequestTranslator;
    }

    @Override
    public void configure() {
        from("spring-rabbitmq:campus.exchange"
                + "?queues=campus.requests.in"
                + "&routingKey=campus.requests.in"
                + "&autoDeclare=false")
                .routeId("smart-campus-request-router")
                .log("Mensaje recibido desde campus.requests.in: ${body}")
                .process(canonicalRequestTranslator)
                .log("Mensaje transformado a formato canónico: ${body}")
                .log("Tipo de solicitud detectado: ${exchangeProperty.requestType}")
                .choice()
                    .when(exchangeProperty("requestType").isEqualTo("ADMISSION"))
                        .log("Enrutando solicitud de admisión")
                        .to("spring-rabbitmq:campus.exchange?routingKey=campus.admissions.queue")
                    .when(exchangeProperty("requestType").isEqualTo("PAYMENT"))
                        .log("Enrutando solicitud de pago")
                        .to("spring-rabbitmq:campus.exchange?routingKey=campus.payments.queue")
                    .when(exchangeProperty("requestType").isEqualTo("SUPPORT"))
                        .log("Enrutando solicitud de soporte")
                        .to("spring-rabbitmq:campus.exchange?routingKey=campus.support.queue")
                    .when(exchangeProperty("requestType").isEqualTo("ACADEMIC"))
                        .log("Enrutando solicitud académica")
                        .to("spring-rabbitmq:campus.exchange?routingKey=campus.academic.queue")
                    .otherwise()
                        .log("Solicitud no reconocida o inválida. Enviando a revisión manual")
                        .to("spring-rabbitmq:campus.exchange?routingKey=campus.manual-review.queue")
                .end();
    }
}
