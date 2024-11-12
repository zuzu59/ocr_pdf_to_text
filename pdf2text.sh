#!/usr/bin/env bash
#Fait un OCR sur tous les fichiers pdf d'un dossier
#zf241112.1502

# Vérifiez si les outils nécessaires sont installés
if ! command -v pdftoppm &> /dev/null || ! command -v tesseract &> /dev/null; then
    echo "Les outils nécessaires (pdftoppm et tesseract) ne sont pas installés."
    echo "Veuillez les installer avec : sudo apt-get install poppler-utils tesseract-ocr"
    exit 1
fi

# Dossier contenant les fichiers PDF
PDF_DIR="~/DATA/pdf/pdf_avant_1996"

# Dossier pour stocker les images temporaires
IMG_DIR="~/DATA/pdf/temp_images"

# Dossier pour stocker les fichiers texte OCR
OUTPUT_DIR="~/DATA/pdf/ocr_output"

# Créez les dossiers nécessaires
echo "Crée les dossiers"
mkdir -p "$IMG_DIR"
mkdir -p "$OUTPUT_DIR"

# Boucle sur tous les fichiers PDF dans le dossier spécifié
echo "Boucle sur tous les pdf trouvés"
for pdf in "$PDF_DIR"/*.pdf; do
    if [ -f "$pdf" ]; then
        # Nom du fichier PDF sans l'extension
        base_name=$(basename "$pdf" .pdf)

	echo $base_name

        # Convertir chaque page du PDF en image PNG
        pdftoppm -png "$pdf" "$IMG_DIR/$base_name"

        # Effectuer l'OCR sur chaque image générée
        for img in "$IMG_DIR/$base_name"-*.png; do
            if [ -f "$img" ]; then
		echo $img
                tesseract "$img" "$OUTPUT_DIR/$base_name" -l eng --psm 6
            fi
        done

        # Combiner tous les fichiers texte en un seul fichier
        cat "$OUTPUT_DIR/$base_name"-*.txt > "$OUTPUT_DIR/$base_name.txt"

        # Supprimer les fichiers texte temporaires
        rm "$OUTPUT_DIR/$base_name"-*.txt
    fi
done

# Supprimer les images temporaires
rm -rf "$IMG_DIR"

echo "L'OCR est terminé. Les fichiers texte sont dans le dossier $OUTPUT_DIR."
