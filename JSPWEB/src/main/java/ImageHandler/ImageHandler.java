package ImageHandler;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/image-upload")
public class ImageHandler {

    @POST
    @Consumes(MediaType.APPLICATION_OCTET_STREAM)
    public Response uploadImage(InputStream imageStream) {
        try {
            // 이미지를 저장할 경로 설정
            String filename = "your_image.jpg"; // 파일명은 원하는 대로 설정하세요.
            Path imagePath = Paths.get("webapp/ImgFiles/" + filename);

            // 이미지를 서버에 저장
            Files.copy(imageStream, imagePath, StandardCopyOption.REPLACE_EXISTING);

            return Response.ok("Image uploaded successfully").type(MediaType.TEXT_PLAIN).build();
        } catch (IOException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Image upload failed").type(MediaType.TEXT_PLAIN).build();
        }
    }
}

