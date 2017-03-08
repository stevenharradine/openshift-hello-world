	FROM nginx:alpine

	COPY index.html /usr/share/nginx/html/index.html

	RUN chmod -R 777 /var/log/nginx /var/cache/nginx/ && chmod 644 /etc/nginx/*

	EXPOSE 80

	CMD ["nginx", "-g", "daemon off;"] 
