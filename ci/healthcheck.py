#!/usr/bin/env python3
"""
Script de contrôle de santé - Lead Exploitation
Interroge l'API capteurs, mesure la latence et vérifie le statut HTTP.
"""

import sys
import os
import time
import urllib.request
import urllib.error

# URL de l'API (surchargée par variable d'environnement si besoin)
API_URL = os.environ.get("API_URL", "http://localhost:8080/health")
# Seuil de latence critique en secondes
MAX_LATENCY_SEC = float(os.environ.get("MAX_LATENCY_SEC", "2.0"))


def check_health():
    print(f"=== [HEALTHCHECK] Diagnostic de l'API Capteurs ===")
    print(f"Cible : {API_URL}")
    print(f"Seuil de latence max : {MAX_LATENCY_SEC}s\n")

    start_time = time.time()
    
    try:
        # Envoi de la requête HTTP GET
        req = urllib.request.Request(API_URL, headers={"User-Agent": "HealthCheck-Script/1.0"})
        with urllib.request.urlopen(req, timeout=5) as response:
            latency = round(time.time() - start_time, 3)
            status_code = response.getcode()
            
            print(f"Code HTTP   : {status_code} OK")
            print(f"Latence     : {latency}s")

            # Validation de la latence
            if latency > MAX_LATENCY_SEC:
                print(f"\n[ECHEC] Latence trop élevée ({latency}s > {MAX_LATENCY_SEC}s)")
                sys.exit(2)

            print("\n[SUCCÈS] L'API Capteurs est totalement opérationnelle.")
            sys.exit(0)

    except urllib.error.HTTPError as e:
        latency = round(time.time() - start_time, 3)
        print(f"Code HTTP   : {e.code} ({e.reason})")
        print(f"Latence     : {latency}s")
        print(f"\n[ECHEC] L'API a répondu avec un code d'erreur HTTP.")
        sys.exit(1)

    except urllib.error.URLError as e:
        print(f"Erreur      : Impossible de joindre l'API ({e.reason})")
        print(f"\n[CRITIQUE] L'API est injoignable (Network / Timeout / Crash).")
        sys.exit(1)

    except Exception as e:
        print(f"Erreur inattendue : {str(e)}")
        sys.exit(3)


if __name__ == "__main__":
    check_health()