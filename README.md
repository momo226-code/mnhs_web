# 🏥 MNHS Web : Moroccan National Health Services Management

Ce projet est une solution de gestion hospitalière (HIS) conçue pour digitaliser et optimiser les flux des services de santé nationaux au Maroc. L'application permet de centraliser la gestion des patients, la prise de rendez-vous et le suivi critique des stocks de médicaments.

## 🚀 Vision du Projet
L'objectif est de répondre aux défis logistiques des structures de santé en utilisant une architecture **Data-Centric**. Le système assure une intégrité totale des données médicales tout en offrant une interface intuitive pour le personnel soignant.

## 🛠️ Stack Technique
* **Backend :** Python & Flask
* **Base de Données :** MySQL (Architecture relationnelle stricte)
* **Data Analysis :** Pandas (Extraction de rapports et KPIs)
* **Frontend :** HTML5 / Jinja2 (Templates dynamiques)

## 📁 Structure du Repository
* `app.py` : Point d'entrée de l'application et gestion des routes Flask.
* `db.py` : Couche d'accès aux données (Data Access Layer) contenant les requêtes SQL optimisées.
* `lab3.sql` : Schéma complet de la base de données (Tables, Relations, Contraintes).
* `templates/` : Interfaces utilisateurs pour la gestion des patients, des stocks et des plannings.

## 🗄️ Architecture des Données
Le cœur du système repose sur un schéma SQL robuste conçu pour la performance :
* **Gestion des relations :** Utilisation de clés étrangères avec `ON DELETE CASCADE` pour garantir la cohérence entre les hôpitaux et leurs départements.
* **Optimisation des requêtes :** Implémentation de tris complexes (ex: tri par nom de famille via `SUBSTRING_INDEX`) directement au niveau de la base de données pour réduire la charge serveur.
* **Sécurité :** Utilisation de variables d'environnement (`python-dotenv`) pour la configuration sécurisée des accès à la base de données.

## 📊 Fonctionnalités Implémentées
* **Gestion des Patients :** Enregistrement et suivi des dossiers médicaux.
* **Prise de Rendez-vous :** Formulaire intelligent de planification (`schedule_form.html`).
* **Logistique Pharmaceutique :** Système d'alerte pour les stocks critiques (`low_stock.html`).
* **Reporting :** Utilisation de Pandas pour transformer les données SQL en insights exploitables pour l'administration hospitalière.

## ⚙️ Installation

1. **Cloner le projet :**
   ```bash
   git clone [https://github.com/momo226-code/mnhs_web.git](https://github.com/momo226-code/mnhs_web.git)
   cd mnhs_web
2. Installer les dependances : pip install -r requirements.txt
3. Configuer la base de données :
   Importer le fichier lab3.sql dans votre serveur MySQL.
   Créer un fichier .env avec vos identifiants
     MYSQL_HOST=localhost
    MYSQL_USER=votre_user
    MYSQL_PASSWORD=votre_password
    MYSQL_DB=lab3
4. Lancez l'application : python app.py
