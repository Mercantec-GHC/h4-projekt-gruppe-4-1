using Amazon.Runtime;
using Amazon.S3.Model;
using Amazon.S3;
using System.IO;

namespace API.Service
{
    public class R2Service
    {
        private readonly IAmazonS3 _s3Client;
        public string AccessKey { get; }
        public string SecretKey { get; }

        public R2Service(string accessKey, string secretKey)
        {
            AccessKey = accessKey;
            SecretKey = secretKey;

            var credentials = new BasicAWSCredentials(accessKey, secretKey);
            var config = new AmazonS3Config
            {
                ServiceURL =
                "https://7edebe7b5106f3bceb95ecd71d962f10.r2.cloudflarestorage.com/eventharmoni",
                ForcePathStyle = true // Ensure the path style is used
            };
            _s3Client = new AmazonS3Client(credentials, config);
        }

        public async Task<string> UploadToR2(Stream fileStream, string fileName)
        {
            var request = new PutObjectRequest
            {
                InputStream = fileStream,
                BucketName = "eventharmoni",
                Key = $"{fileName}.png",
                DisablePayloadSigning = true
            };

            var response = await _s3Client.PutObjectAsync(request);

            if (response.HttpStatusCode != System.Net.HttpStatusCode.OK)
            {
                throw new AmazonS3Exception
                (
                $"Error uploading file to S3. HTTP Status Code: {response.HttpStatusCode}"
                );
            }

            var imageUrl = $"https://eventharmoni.mercantec.tech/eventharmoni/{fileName}.png";
            return imageUrl;
        }

        public async Task DeleteFromR2(Stream fileStream, string fileUrl)
        {
            // Extract the object key from the fileUrl
            var objectKey = ExtractObjectKeyFromUrl(fileUrl);

            // Use Amazon S3 SDK to delete the object (since R2 is S3-compatible)
            var client = new AmazonS3Client(AccessKey, SecretKey, Amazon.RegionEndpoint.USEast1);  // Adjust the endpoint to your R2 region

            var deleteRequest = new DeleteObjectRequest
            {
                InputStream = fileStream,
                BucketName = "eventharmoni",
                Key = $"{fileUrl}.png",
                DisablePayloadSigning = true
            };

            try
            {
                var response = await client.DeleteObjectAsync(deleteRequest);

                // Optionally handle the response if needed
                if (response.HttpStatusCode != System.Net.HttpStatusCode.NoContent)
                {
                    throw new Exception("Error deleting object from R2.");
                }
            }
            catch (AmazonS3Exception e)
            {
                // Handle the error (log, rethrow, etc.)
                throw new Exception($"Error encountered on server. Message:'{e.Message}' when deleting an object");
            }
        }

        // Helper method to extract the object key from a full URL
        private string ExtractObjectKeyFromUrl(string fileUrl)
        {
            // Logic to extract the object key (file name) from the URL, depending on how your URLs are structured.
            // Example: Remove domain from the URL and return the key
            var uri = new Uri(fileUrl);
            return uri.AbsolutePath.TrimStart('/');
        }
    }
}