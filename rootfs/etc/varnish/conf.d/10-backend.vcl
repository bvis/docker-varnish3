
backend default {
  .host = "web";
  .port = "8080";
  .probe = {
           .url = "/";
           .interval = 5s;
           .timeout = 1 s;
           .window = 5;
           .threshold = 3;
      }
}
