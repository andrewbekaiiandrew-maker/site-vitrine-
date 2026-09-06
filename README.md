# Site Vitrine Professionnel

Un site vitrine moderne, responsive et animé pour votre commerce.

## Structure du projet

```
site-vitrine/
├── index.html          ← Page principale du site
├── css/
│   └── style.css       ← Tous les styles (responsive + animations)
├── js/
│   └── script.js       ← Navigation, animations, WhatsApp
├── images/             ← Vos photos ici
├── package.json        ← Configuration du projet
├── start-server.bat    ← Lance le serveur local
├── open.bat            ← Ouvre le site dans le navigateur
└── site-vitrine.lnk    ← Raccourci permanent
```

## Personnalisation

Ouvrez `index.html` et remplacez tous les éléments entre crochets `[...]` :

- `[Nom du Commerce]` → Votre nom d'entreprise
- `[Titre accrocheur du commerce]` → Votre accroche
- `[Description du commerce]` → Votre présentation
- `[NuméroWhatsApp]` → Votre numéro WhatsApp (ex: 33612345678)
- `[Heures d'ouverture]` → Vos horaires
- `[Adresse complète]` → Votre adresse
- `[Numéro de téléphone]` → Votre téléphone
- `[Adresse email]` → Votre email
- `[Icône ou image]` → Une icône ou emoji

Les fichiers images à personnaliser dans le dossier `images/` :
- `hero-image.jpg` (image de la section hero)
- `presentation.jpg` (image de présentation)

## Hébergement

### Option 1 : GitHub Pages (GRATUIT)

1. Créez un compte sur [github.com](https://github.com)
2. Ouvrez un terminal et tapez :
   ```
   git remote add origin https://github.com/VOTRE_PSEUDO/site-vitrine.git
   git push -u origin main
   ```
3. Sur GitHub, allez dans Settings → Pages → Source : `main` → Save
4. Votre site sera accessible à `https://VOTRE_PSEUDO.github.io/site-vitrine/`

### Option 2 : Netlify (GRATUIT, 1 clic)

1. Allez sur [netlify.com](https://netlify.com)
2. Créez un compte
3. Glissez-déposez le dossier `site-vitrine` dans la zone indiquée
4. Votre site est en ligne immédiatement avec un lien du type `votre-site.netlify.app`

### Option 3 : Vercel (GRATUIT)

1. Allez sur [vercel.com](https://vercel.com)
2. Connectez-vous
3. Cliquez sur "New Project" → Importez le dossier `site-vitrine`
4. C'est déployé en quelques secondes

## Lancer en local

```
./start-server.bat
```
Puis ouvrez `http://localhost:8080` dans votre navigateur.

Ou simplement double-cliquez sur `site-vitrine.lnk`.
