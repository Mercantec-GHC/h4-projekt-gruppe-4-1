using Amazon.Runtime;
using Amazon.S3.Model;
using Amazon.S3;

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
    }
}