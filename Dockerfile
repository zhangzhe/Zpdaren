FROM index.alauda.cn/library/rails:onbuild

RUN apt-get update && apt-get install -y nginx
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default
COPY config/nginx.conf /etc/nginx/nginx.conf

RUN bundle exec rake assets:precompile RAILS_ENV=production

RUN mkdir -p tmp/pids

EXPOSE 80

CMD sh start.sh
