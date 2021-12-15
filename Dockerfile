FROM ubuntu

RUN apt-get update && apt-get install -y fio

COPY perform-test.sh ~/perform-test.sh

CMD ["/bin/bash", "~/perform-test.sh"]