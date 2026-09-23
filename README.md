# projet-ajc-foodtrack

Dépôt du projet final de la formation AJC Ingénieur Cloud OPS

# Dimensionnement GKE

Le Bastion SSH (e2-micro)
Ce choix repose sur le principe du moindre privilège et de l'optimisation des coûts. L'instance e2-micro offre 2 vCPU partagés et 1 Go de RAM, ce qui est largement suffisant pour jouer son rôle de pont sécurisé vers le réseau privé de GCP. Comme elle ne traite aucune charge applicative et ne sert qu'à relayer tes commandes kubectl ou tes accès SSH, surdimensionner cette machine serait un gaspillage budgétaire, d'autant qu'elle rentre dans le cadre des ressources à très faible coût de GCP.

Le nombre de nœuds GKE (node_count = 2)
Le choix d'un cluster à deux nœuds permet de garantir la haute disponibilité minimale requise par Kubernetes tout en limitant les frais d'infrastructure. Déployer un seul nœud créerait un point unique de défaillance (Single Point of Failure), rendant le système vulnérable à la moindre maintenance ou panne d'instance. Avec deux worker nodes, Kubernetes peut répartir intelligemment les Pods applicatifs, assurer la résilience de vos microservices et valider le comportement du cluster en conditions réelles sans multiplier la facture par trois ou quatre.

Le type de machine des nœuds (machine_type = "e2-standard-2")
En attribuant 2 vCPU et 8 Go de RAM par nœud, le cluster dispose d'un total cumulé de 4 vCPU et 16 Go de mémoire vive. Ce dimensionnement est idéal car les composants internes de Kubernetes (comme le CNI, le CSI ou le metrics-server) consomment déjà entre 1 et 1,5 Go de RAM par nœud. Des machines plus petites comme des e2-micro ou e2-small provoqueraient rapidement des pannes par manque de mémoire (Out Of Memory), tandis que cette configuration offre la marge nécessaire pour faire tourner l'ensemble des conteneurs applicatifs de manière stable.

La taille des disques système (node_disk_size_gb = 50)
Chaque nœud embarque un disque persistant de 50 Go, ce qui représente le parfait compromis pour un environnement de développement et de test. L'système d'exploitation des nœuds (Container-Optimized OS) étant très léger, il occupe moins de 5 Go d'espace. Les 45 Go restants sont alloués au stockage des images Docker en cache et aux volumes temporaires des Pods. Réduire la taille par défaut de GCP (qui est de 100 Go) à 50 Go permet de diviser immédiatement par deux la facture liée au stockage bloc sans impacter les performances de vos déploiements.

# Kustomize

Nous avons choisi de partir sur Kustomize pour la séparation par environnement pour sa facilité d'exécution et ses capacités adaptées à notre projet de petite envergure. De plus, Kustomize est présent directement dans Cloud Shell.

Créer une copie de fichier par environnement pose un véritable problème d'optimisation, tandis qu'envsubst ne propose pas les avantages de confort de Kustomize.
Nous avons également consideré Helm pour réaliser ce projet, mais après de plus amples recherches et discussions au sein du groupe, nous en avons conclu qu'il était trop fourni pour un projet de cette taille.

## Changements effectués par environnement dans Kustomize :

| Fichier concerné dans la base     | Cible                           | Path de l'attribut patched                                   | Valeur dans la base                                                  | Valeur dans l'environnement de développement | Valeur dans l'environnement de test        | Valeur dans l'environnement de production  | <div style="width:5=300px">Justification</div>                                                                                                                                                                                                                                                                                                |
| --------------------------------- | ------------------------------- | ------------------------------------------------------------ | -------------------------------------------------------------------- | -------------------------------------------- | ------------------------------------------ | ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 00-namespace.yaml                 | Le Namespace "foodtrack"        | /metadata/name                                               | foodtrack                                                            | foodtrack-dev                                | foodtrack-test                             | foodtrack-prod                             | Il est demandé dans le cahier des charges d'avoir un namespace différent par environnement                                                                                                                                                                                                                                                    |
| 00-namespace.yaml                 | Le Namespace "foodtrack"        | /metadata/labels/foodtrack.example~1env                      | dev                                                                  | dev                                          | test                                       | prod                                       | foodtrack.example/env est un indicateur de l'environnement comme label assigné au namespace.                                                                                                                                                                                                                                                  |
| 01-configmap.yaml                 | La ConfigMap "foodtrack-config" | /data/SEUIL_TEMPERATURE_C                                    | 4                                                                    | 10                                           | 5                                          | 4                                          | En développement, 10 est utilisé comme une variable placeholder, choisie arbitrairement. On suppose une situation où 5 s'avère être une valeur fonctionnelle en environnement de test, mais on utilisera 4 en environnement de production pour une couche supplémentaire de sécurité en déclenchant des alarmes à une température plus basse. |
| 01-configmap.yaml                 | La ConfigMap "foodtrack-config" | /data/NIVEAU_JOURNAL                                         | debug                                                                | debug                                        | info                                       | warn                                       | En dev puis en test, on utilise des niveaux plus bas car on provoquera volontairement des alertes. En environnement de production, on attend un niveau plus élevé de log car une alerte est réelle                                                                                                                                            |
| 01-configmap.yaml                 | La ConfigMap "foodtrack-config" | /data/index.html                                             | [...]\<p>Environnement : a differencier par environnement.\</p>[...] | [...]\<p\>Environnement : dev.\</p\>[...]    | [...]\<p\>Environnement : test.\</p\>[...] | [...]\<p\>Environnement : prod.\</p\>[...] | La page de l'API doit afficher l'environnement actuel                                                                                                                                                                                                                                                                                         |
| 03-deployment-portail-qualite.yml | Le Deployment "portail-qualite" | /spec/replicas                                               | 2                                                                    | 1                                            | 2                                          | 3                                          | On n'a pas besoin de plus de répliques en dev car on ne fait que développer l'app, pas tester sa disponibilité; On en met 2 en test pour faire ces tests de disponibilité puis 3 en production pour garantir sa disponibilité auprès des utilisateurs.                                                                                        |
| 03-deployment-portail-qualite.yml | Le Deployment "portail-qualite" | /spec/strategy/rollingUpdate/maxSurge                        | 1                                                                    | 1                                            | 1                                          | 2                                          | Notre budget étant réduit, on n'alloue que 2 pods en Surge à l'environnement de producton pour garantir la disponibilité de l'app lors des updates.                                                                                                                                                                                           |
| 04-deployment-api-capteurs.yml    | Le Deployment "api-capteurs"    | /spec/replicas                                               | 2                                                                    | 1                                            | 2                                          | 3                                          | *Voir justification pour le Deployment "portail-qualite"*                                                                                                                                                                                                                                                                                     |
| 04-deployment-api-capteurs.yml    | Le Deployment "api-capteurs"    | /spec/strategy/rollingUpdate/maxSurge                        | 1                                                                    | 1                                            | 1                                          | 2                                          | *Voir justification pour le Deployment "portail-qualite"*                                                                                                                                                                                                                                                                                     |
| 05-statefulset-cache-releves.yaml | Le StatefulSet "cache-reveles"  | /spec/volumeClaimTemplates/0/spec/resources/requests/storage | 10Gi                                                                 | 10Gi                                         | 30Gi                                       | 50Gi                                       | On aura besoin de plus de stockage lors du déploiement en production. On alloue 30 à test pour ne pas provoquer des erreurs à cause du manque de cache, mais 50Gi ne sont pas nécessaires.                                                                                                                                                    |

Nous avons aussi ajouté deux snippet de YAML dans chaque fichier `kustomization.yaml` :

##### secretGenerator

```yaml
secretGenerator:
- name: foodtrack-api-config
  envs:
  - secret.env
```

C'est un générateur de secret. Une approche qui utilise un fichier de variables d'environnement (`envs`, plutôt que `literals` ou `files`) permet de récupérer les secrets dans le fichier `secret.env`, ajouté au .gitignore, lors du build, sans jamais les écrire en clair dans un manifest (ce que fait `literals`) ou un fichier texte (ce que fait `files`). Les fichiers d'environnement ne sont pas push sur notre dépôt.

##### Fichier de patch pour le Horizontal Pod Autoscaler

```yaml
- path: HPA-foodtrack-patch.yaml
```

qui ajoute les patches contenus dans le fichier `HPA-foodtrack-patch.yaml`, qui remplacent les valeurs dans `HPA-foodtrack.yaml` et sont les suivants :

- Environnement de développement :

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-capteurs
spec:
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
```

- Environnement de test :

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-capteurs
spec:
  minReplicas: 2
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

- Environnement de production :

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-capteurs
spec:
  minReplicas: 3
  maxReplicas: 6
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
```

On justifie ces patches par les besoins plus grands dans un environnement de production que dans un environnement de développement ou de testing en quantité de répliques, car la disponibilité de l'application est une priorité ; Du côté de l'utilisation CPU, on peut supporter une utilisation plus élevée en environnement de développement ou de test pour tester l'application mais on préfère la réduire en production pour éviter des crashes. 
| Fichier concerné dans la base     | Cible                           | Path de l'attribut patched              | Valeur dans la base                                                  | Valeur dans l'environnement de développement | Valeur dans l'environnement de test        | Valeur dans l'environnement de production  | <div style="width:5=300px">Justification</div>                                                                                                                                                                                                                                                                                                |
| --------------------------------- | ------------------------------- | --------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------- | ------------------------------------------ | ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 00-namespace.yaml                 | Le Namespace "foodtrack"        | /metadata/name                          | foodtrack                                                            | foodtrack-dev                                | foodtrack-test                             | foodtrack-prod                             | Il est demandé dans le cahier des charges d'avoir un namespace différent par environnement                                                                                                                                                                                                                                                    |
| 00-namespace.yaml                 | Le Namespace "foodtrack"        | /metadata/labels/foodtrack.example~1env | dev                                                                  | dev                                          | test                                       | prod                                       | foodtrack.example/env est un indicateur de l'environnement comme label assigné au namespace.                                                                                                                                                                                                                                                  |
| 01-configmap.yaml                 | La ConfigMap "foodtrack-config" | /data/SEUIL_TEMPERATURE_C               | 4                                                                    | 10                                           | 5                                          | 4                                          | En développement, 10 est utilisé comme une variable placeholder, choisie arbitrairement. On suppose une situation où 5 s'avère être une valeur fonctionnelle en environnement de test, mais on utilisera 4 en environnement de production pour une couche supplémentaire de sécurité en déclenchant des alarmes à une température plus basse. |
| 01-configmap.yaml                 | La ConfigMap "foodtrack-config" | /data/NIVEAU_JOURNAL                    | debug                                                                | debug                                        | info                                       | warn                                       | En dev puis en test, on utilise des niveaux plus bas car on provoquera volontairement des alertes. En environnement de production, on attend un niveau plus élevé de log car une alerte est réelle                                                                                                                                            |
| 01-configmap.yaml                 | La ConfigMap "foodtrack-config" | /data/index.html                        | [...]\<p>Environnement : a differencier par environnement.\</p>[...] | [...]\<p\>Environnement : dev.\</p\>[...]    | [...]\<p\>Environnement : test.\</p\>[...] | [...]\<p\>Environnement : prod.\</p\>[...] | La page de l'API doit afficher l'environnement actuel                                                                                                                                                                                                                                                                                         |
| 03-deployment-portail-qualite.yml | Le Deployment "portail-qualite" | /spec/replicas                          | 2                                                                    | 1                                            | 2                                          | 3                                          | On n'a pas besoin de plus de répliques en dev car on ne fait que développer l'app, pas tester sa disponibilité; On en met 2 en test pour faire ces tests de disponibilité puis 3 en production pour garantir sa disponibilité auprès des utilisateurs.                                                                                        |
| 03-deployment-portail-qualite.yml | Le Deployment "portail-qualite" | /spec/strategy/rollingUpdate/maxSurge   | 1                                                                    | 1                                            | 1                                          | 2                                          | Notre budget étant réduit, on n'alloue que 2 pods en Surge à l'environnement de producton pour garantir la disponibilité de l'app lors des updates.                                                                                                                                                                                           |
| 04-deployment-api-capteurs.yml    | Le Deployment "api-capteurs"    | /spec/replicas                          | 2                                                                    | 1                                            | 2                                          | 3                                          | *Voir justification pour le Deployment "portail-qualite"*                                                                                                                                                                                                                                                                                     |
| 04-deployment-api-capteurs.yml    | Le Deployment "api-capteurs"    | /spec/strategy/rollingUpdate/maxSurge   | 1                                                                    | 1                                            | 1                                          | 2                                          | *Voir justification pour le Deployment "portail-qualite"*                                                                                                                                                                                                                                                                                     |
|                                   |                                 |                                         |                                                                      |                                              |                                            |                                            |                                                                                                                                                                                                                                                                                                                                               |
|                                   |                                 |                                         |                                                                      |                                              |                                            |                                            |                                                                                                                                                                                                                                                                                                                                               |
|                                   |                                 |                                         |                                                                      |                                              |                                            |                                            |                                                                                                                                                                                                                                                                                                                                               |
|                                   |                                 |                                         |                                                                      |                                              |                                            |                                            |                                                                                                                                                                                                                                                                                                                                               |

# Justification des choix d'implémentation du script de contrôle de santé :

Pour assurer la supervisabilité de l'API capteurs en phase d'exploitation, nous avons développé un script Python autonome qui évalue non seulement la disponibilité globale (statut HTTP 200), mais aussi la qualité de service en mesurant la latence d'exécution. Pour garantir une empreinte mémoire minimale et faciliter son déploiement dans des conteneurs légers ou des CronJobs Kubernetes, le script repose exclusivement sur la bibliothèque standard Python (urllib, time, sys), éliminant ainsi toute dépendance externe. Il suit strictement les normes d'exécution UNIX en renvoyant un code de sortie explicite (0 pour un fonctionnement nominal, 1 en cas de panne applicative ou réseau, et 2 en cas de dégradation de la latence) pour permettre l'interruption immédiate des pipelines CI/CD en cas d'anomalie. Enfin, la paramétrisation dynamique des cibles et des seuils tolérés via des variables d'environnement (API_URL, MAX_LATENCY_SEC) garantit sa réutilisabilité intégrale à travers les différents environnements de déploiement (développement, test, prod).
