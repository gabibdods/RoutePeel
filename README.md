# 🧅 Deep Web Exploration with Tails and Tor Relays

A practical cybersecurity experiment to deepen understanding of Tor networks/relays, .onion websites, and anonymous browsing practices using the **Tails**, an operating system built specifically for privacy and security, acronym for The Amnesic Incognito Live System. This project demonstrates secure navigation of the dark web and onion services, including a connection to DuckDuckGo’s onion mirror.

---

## 🔍 Problem Statement

Reading about Tor and the deep web provides theoretical knowledge, but I wanted **real-world, hands-on experience** with:
- Navigating .onion services securely
- Understanding how Tor relays work
- Using privacy-preserving operating systems
- Verifying digital signatures for secure system installations

---

## 🎯 Project Goals

- Connect securely to an **onion website** (DuckDuckGo's: `https://3g2upl4pq6kufc4m.onion`) through **multiple Tor relays**
- Use **Tails**, a Debian-based Linux distribution designed for anonymity
- Explore **practical privacy measures** like bootable OS environments, digital signature verification, and system memory clearing
- Learn about the intersection of OS security, network anonymization, and open-source tooling

---

## 🛠️ Tools & Technologies Used

- **Tails** — Live security-focused Linux distribution (from [tails.net](https://tails.net))
- **Tor Browser** — Integrated within Tails for anonymous browsing via Tor relays
- **Boot Drive** — Used to install and boot Tails
- **Balena Etcher** — Tool to flash the Tails image onto the USB drive
- **OpenPGP** — Used to verify the authenticity of the downloaded Tails image
- **David Bombal / TCM Security** — Educational resources that guided setup and deepened my understanding

---

## 🔐 Setup Process

1. **Downloaded Tails image** and its `.sig` file from the [official Tails website](https://tails.net)
2. **Verified the image** using OpenPGP to ensure integrity and authenticity
3. Used **Balena Etcher** to flash the verified image onto a USB drive
4. Booted into **Tails** from the USB drive
5. Launched **Tor Browser** within Tails
6. Successfully accessed DuckDuckGo’s onion address: `https://3g2upl4pq6kufc4m.onion` through the Tor network

---

## ⚙️ How to Create a Tails Bootable Drive

Here’s how I set up Tails from scratch for this project:

### 1️⃣ Download the Tails ISO

- Open your browser and download the latest **Tails ISO image** from the [official Tails website](https://tails.net).

### 2️⃣ Flash the ISO to a USB Drive

- Use the **Balena Etcher** software (or similar) to flash the Tails image onto a USB drive.
- This turns the USB drive into a **bootable Tails drive**.

### 3️⃣ Boot from the USB Drive

- Plug in the bootable USB drive to your computer.
- Restart the computer and enter the **boot menu** by pressing a key during startup (`ESC`, `F2`, or `F12`, depending on your motherboard).

### 4️⃣ Configure the BIOS

- In the boot menu, **select the USB drive** as the boot device.

### 5️⃣ Set Up Tails

- Follow the Tails prompts to prepare the system for production use.
- Choose language settings, keyboard layout, and connect to the Tor network.

---

## 🚀 Access the Deep Web

Once booted into Tails:

1. Launch the **Tor Browser** (built into Tails).
2. Visit DuckDuckGo’s .onion mirror: https://3g2upl4pq6kufc4m.onion
3. Explore other `.onion` services cautiously and anonymously.

---

## 🛠️ Additional Tips

✅ **Verify the ISO signature** (with OpenPGP) to ensure your download is authentic and secure.  
✅ **Always use trusted sources** when downloading privacy-focused OSs and tools.  
✅ **Avoid using personal accounts** or identifying information when exploring the deep web.

---

## 📈 Challenges Faced

- Properly configuring and verifying the Tails bootable drive
- Understanding how to route and test Tor connections via relays
- Getting familiar with Tails-specific behaviors (e.g., session-based file system, non-persistence)

**Solution:** Followed an in-depth tutorial from cybersecurity expert **David Bombal**, who originally inspired this project through his interviews and practical demonstrations.

---

## 📚 Lessons Learned

### 🌐 Cybersecurity Knowledge
- **The most important lesson:** the public internet — especially the deep web — contains **serious threats**, including individuals with malicious intent.
  - It's crucial to use **all recommended precautions**:
    - Route through multiple **Tor relays (nodes)**
    - Ensure all traffic is **encrypted**
    - Use **privacy-focused OSs** like Tails
    - Rely on trusted browsers (like the **Tor Browser**) and verified images
- Learned how Tor anonymizes traffic using a layered relay model
- Understood the strict security and anonymity features of **Tails**
- Gained practical knowledge of .onion domains and their risks

### 🧪 Practical Skills
- Verified software integrity with **OpenPGP**
- Flashed and booted secure **live USB systems**
- Explored **deep web access** under anonymized, controlled conditions

---

## 🚀 Future Enhancements

- Explore building a **.onion service** of my own
- Set up and configure a personal **non-exit Tor relay node**
- Use **Whonix** or **Qubes OS** to compare different privacy-focused operating systems
- Begin learning **penetration testing tools** like Metasploit or Nmap inside isolated environments

---

## 🖥️ Architecture Overview

```plaintext
+--------------------------+
|  Bootable USB Drive      |
|  (Tails OS Environment)  |
+-----------+--------------+
            |
            v
+--------------------------+
|     Tails OS Boots       |
| RAM-based, non-persistent|
+-----------+--------------+
            |
            v
+--------------------------+
|   Tor Browser Launches   |
|   Built-in to Tails OS   |
+-----------+--------------+
            |
            v
+--------------------------+
| Connect to Tor Network   |
| - Entry Guard Node       |
| - Middle Relay Node      |
| - Exit Node (N/A for .onion) |
+-----------+--------------+
            |
            v
+--------------------------+
| .onion Request Routed    |
|  via Hidden Service Dir  |
+-----------+--------------+
            |
            v
+--------------------------+
| DuckDuckGo .onion Server |
| (3g2upl4pq6kufc4m.onion) |
+--------------------------+
