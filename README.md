# IML-Course-Summary
This repository contains my **personal course summary** for  
**67577 – Introduction to Machine Learning** at **The Hebrew University of Jerusalem**.
> The summary is available as a PDF file [**here**](https://github.com/OrF8/IML-Course-Summary/blob/main/%D7%9E%D7%91%D7%95%D7%90%20%D7%9C%D7%9C%D7%9E%D7%99%D7%93%D7%AA%20%D7%9E%D7%9B%D7%95%D7%A0%D7%94%20-%20%D7%A1%D7%99%D7%9B%D7%95%D7%9D%20%D7%94%D7%A7%D7%95%D7%A8%D7%A1%20-%20%D7%A1%D7%9E%D7%A1%D7%98%D7%A8%20%D7%90'%202026.pdf).
> It can also be found in my Google Drive, [**here**](https://drive.google.com/file/d/1IqSWcBgL1cc4mEHYV5vH7OXbfw01RHfH/view?usp=drive_link)

---

## 📁 Repository Contents

- **Course summary (DOCX)**  
  The main editable source file.

- **Course summary (PDF)**  
  Automatically generated from the DOCX:
  - high image quality (print-optimized)
  - bookmarks created from Word *Heading* styles

- **GIFs /**  
  Visual explanations (e.g., gradient descent behavior, learning rate effects).

- **Viz (PPTX)**  
  Supporting visualizations material used in the summary.

---

## 🔄 Workflow Overview

This repository is maintained using a **single sync script** that performs:

1. Pull latest changes from `main`
2. Export the newest `.docx` → `.pdf`
   - includes bookmarks from headings
   - optimized for image quality
   - skips export if the PDF is already up-to-date
3. Show staged changes
4. Commit with an optional custom message
5. Push to GitHub
6. Optionally create and push a **named git tag**

This ensures the PDF is always consistent with the DOCX and that the history stays clean.

---

## 📦 Large Files (Git LFS)

This repository uses **Git Large File Storage (LFS)** for:

- `.pdf`
- `.docx`
- `.gif`

If you clone this repo, make sure Git LFS is installed:

```bash
git lfs install
git lfs pull
```

---

## 📝 Notes
- PDF bookmarks are generated from **Word Heading styles**
- The repo is optimized for personal study and revision, not as an official course resource

---

## ⚠️ Disclaimer
These notes reflect **my personal understanding** of the course material.
They may contain mistakes or omissions and are **not a substitute** for official lectures, slides, or textbooks.

---

## 📜 License

This repository is licensed under  
**Creative Commons Attribution–NonCommercial–ShareAlike 4.0 (CC BY-NC-SA 4.0)**.

You are free to use and adapt the material for **non-commercial educational purposes**,  
provided proper attribution is given and derivative works use the same license.
For more information, see the [LICENSE](https://github.com/OrF8/IML-Course-Summary/blob/main/LICENSE).

