cd /tmp
cat > TestCharset.java << 'EOF'
public class TestCharset {
    public static void main(String[] args) {
        System.out.println("isSupported: " + java.nio.charset.Charset.isSupported("X-Mazovia"));
        try {
            java.nio.charset.Charset cs = java.nio.charset.Charset.forName("X-Mazovia");
            System.out.println("Loaded OK: " + cs);
        } catch (Throwable t) {
            System.out.println("FAILED with:");
            t.printStackTrace();
        }
    }
}
EOF
