docker build -t elenakves/multi-client:latest -t elenakves/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t elenakves/multi-server:latest -t elenakves/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t elenakves/multi-worker:latest -t elenakves/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push elenakves/multi-client:latest
docker push elenakves/multi-server:latest
docker push elenakves/multi-worker:latest

docker push elenakves/multi-client:$SHA
docker push elenakves/multi-server:$SHA
docker push elenakves/multi-worker:$SHA

kubectl apply -f k8s # kubectl is configured in .travis.yaml  to go to GC
kubectl set image deployments/server-deployment server=elenakves/multi-server:$SHA
kubectl set image deployments/client-deployment client=elenakves/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=elenakves/multi-worker:$SHA