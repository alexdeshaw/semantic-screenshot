# Semantic Screenshot for macOS 📸

An automated screenshot naming tool for macOS that extracts text from screenshots using **Tesseract OCR** and **spaCy NLP**, then renames them based on their content.  

No more **"Screenshot 2025-02-02 at 14.30.12.png"**—now your screenshots get meaningful, content-based filenames automatically. 🚀

## Features
✅ **Automatic screenshot naming** based on detected text  
✅ **Uses OCR (Tesseract) and NLP (spaCy) to generate semantic filenames**  
✅ **Works with Automator as a macOS app for one-click use**  
✅ **Lightweight, runs fully locally, no cloud required**  
✅ **Can be integrated into scripts, shortcuts, or other workflows**  

---

## 🔧 Installation & Setup

### 1️⃣ **Install Dependencies**
#### **Install Tesseract OCR (Required)**
```bash
brew install tesseract
```
#### **Set Up a Python Virtual Environment**
```bash
python3 -m venv ~/spacy_env
source ~/spacy_env/bin/activate
pip install spacy tesseract
python -m spacy download en_core_web_sm
```

---

### 2️⃣ **Set Up the Screenshot Script**
Clone the repository and give the script execution permissions:
```bash
git clone https://github.com/alexdeshaw/semantic-screenshot.git
cd semantic-screenshot
chmod +x screenshot.sh
```

---

### 3️⃣ **Where Screenshots Are Saved (And How to Change It)**
By default, all screenshots are saved to:
```
~/Documents/Screenshots
```
If you want to change the save location, edit the **`screenshot.sh`** script:
```bash
# Change this line in screenshot.sh
output_dir=~/Documents/Screenshots
```
For example, to save screenshots to your Desktop:
```bash
output_dir=~/Desktop/Screenshots
```
After making changes, **save the file and restart Automator (if using an app).**  

---

### 4️⃣ **Integration Methods**
#### ✅ **Option 1: Automator App (Recommended)**
1. Open **Automator** (`Cmd + Space`, type `Automator`).
2. Select **New Application**.
3. Add a **"Run Shell Script"** action.
4. Paste the full path to `screenshot.sh` inside.
5. Save it as **"Semantic Screenshot.app"** and drag it to your **Dock** for easy access.
6. Click the app → Take a screenshot → It gets saved & renamed instantly. 🚀

#### ✅ **Option 2: Run from Terminal**
If you don’t want an Automator app, just run:
```bash
./screenshot.sh
```
This will trigger the interactive screenshot tool and rename the file automatically.

#### ✅ **Option 3: Assign a Global Shortcut**
1. Open **System Settings → Keyboard → Shortcuts**.
2. Go to **Services → Screenshot**.
3. Assign a custom shortcut to execute `screenshot.sh`.

---

## 📝 License
This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

### 📜 **Third-Party Dependencies**
- **Tesseract OCR** (Apache 2.0)  
- **spaCy NLP** (MIT License)  

Both are open-source and allow free usage/modification.

---

## 💡 Notes
- This script **only runs on macOS**.
- **If OCR results are poor**, make sure **Tesseract is installed correctly** and try adjusting the **screenshot quality**.
- For **best accuracy**, take screenshots with **clear, readable text**.

🚀 Enjoy **semantic screenshot naming** and never deal with generic filenames again!  
