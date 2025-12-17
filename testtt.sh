import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpExchange;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.stream.Collectors;

public class HeaderServer {

    public static void main(String[] args) throws Exception {
        int port = 8213;

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/headers", (HttpExchange exchange) -> {

            String headers = exchange.getRequestHeaders().entrySet().stream()
                .map(e -> e.getKey() + " = " + e.getValue())
                .collect(Collectors.joining("\n"));

            String response = "HEADERS RECEIVED:\n\n" + headers;

            exchange.sendResponseHeaders(200, response.getBytes().length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        });

        server.start();
        System.out.println("Header test server running on port " + port);
    }
}
