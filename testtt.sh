@SpringBootApplication
@RestController
public class HeaderTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(HeaderTestApplication.class, args);
    }

    @GetMapping("/headers")
    public Map<String, String> headers(HttpServletRequest request) {
        Map<String, String> map = new HashMap<>();
        Collections.list(request.getHeaderNames())
                .forEach(h -> map.put(h, request.getHeader(h)));
        return map;
    }
}
