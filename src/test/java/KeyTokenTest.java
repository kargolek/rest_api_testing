import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

public class KeyTokenTest {

    @Test
    public void should_api_key(){
        assertTrue(System.getenv().get("trl_key").contains("239"));
    }

    @Test
    public void should_api_token(){
        assertTrue(System.getenv().get("trl_token").contains("875"));
    }
}