html2pdf server
==========

## boot server

```
sudo docker run -it --rm -p 80:80 shouldbee/html2pdf
```

## client

```
curl http://localhost/?url=http://www.google.com/ | base64 -d > google.pdf
```
