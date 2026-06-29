import '../models/pest_model.dart';

class PestData {
  static List<Pest> allPests = [
    // ========================================================
    // 1. KUTU DAUN (Aphis gossypii)
    // ========================================================
    Pest(
      name: "Kutu Daun",
      scientificName: "Aphis gossypii",
      imagePath: "assets/images/kutu_daun.jpg",
      description: "Kutu daun, seperti Aphis gossypii, merupakan hama penting pada tanaman cabai yang menyerang dengan cara mengisap cairan pada daun, tangkai, bunga, dan buah. Aktivitas tersebut menyebabkan gejala kerusakan seperti daun keriting, pertumbuhan terhambat, dan penurunan kualitas hasil panen. A. gossypii juga berfungsi sebagai vektor virus, seperti virus mosaik dan virus keriting daun, yang dapat menyebar antartanaman dalam jarak yang relatif jauh. Dampak dari infeksi virus yang dibawa oleh kutu daun ini dapat menyebabkan kerugian hasil hingga lebih dari 90%. Secara morfologis, kutu daun memiliki tubuh kecil dengan variasi warna seperti hijau, hitam, atau cokelat tergantung pada spesiesnya, dan umumnya ditemukan dalam kelompok (koloni) di bagian bawah daun muda.",
      gallery: [
        "assets/images/kutu_daun_1.jpg",
        "assets/images/kutu_daun_2.jpg",
      ],
      // Bagian rekomendasi penanggulangan (Pestisida)
      pesticides: [
        "Pestisida Kimiawi: Disarankan menggunakan bahan aktif yang selektif seperti Pimetrozin atau Thiametoksam untuk meminimalkan dampak negatif terhadap musuh alami di ekosistem.",
      ],
      // Bagian murni referensi/sitasi literatur dan gambar
      sources: [
        "Gambar: Kompas Homey (2025). Cara Ampuh Membasmi Kutu Daun di Tanaman Cabai.",
        "Sitorus, R. H., & Wilyus. Pengelolaan Hama Terpadu (PHT) Kutu Kebul, Kutu Daun (Aphids) dan Thrips pada Tanaman Cabai Keriting. Jurnal Media Pertanian (Jagro), 2023.",
        "Rahman, T., Roff, M. N. M., & Ghani, I. B. A. Within-field distribution of Aphis gossypii and aphidophagous lady beetles in chili. Entomologia Experimentalis et Applicata, 2010.",
      ],
    ),

    // ========================================================
    // 2. KUTU KEBUL (Bemisia tabaci)
    // ========================================================
    Pest(
      name: "Kutu Kebul",
      scientificName: "Bemisia tabaci",
      imagePath: "assets/images/kutu_kebul.jpg",
      description: "Kutu kebul (Bemisia tabaci) merupakan salah satu hama utama pada tanaman cabai, khususnya cabai merah keriting. Hama ini menyerang dengan cara mengisap cairan pada daun, terutama bagian daun muda dan pucuk tanaman, yang menyebabkan daun mengalami klorosis, menggulung, dan pertumbuhan tanaman menjadi kerdil. Selain itu, kutu kebul berperan sebagai vektor virus Pepper Yellow Leaf Curl Virus (PYLCV) dari genus Begomovirus, yang mengakibatkan penyakit daun keriting kuning. Infeksi virus pada fase awal pertumbuhan tanaman dapat menyebabkan gangguan pertumbuhan secara signifikan dan penurunan produksi buah, bahkan berpotensi menyebabkan puso apabila tidak dikendalikan. Ciri morfologis kutu kebul antara lain berukuran kecil, berwarna putih seperti dilapisi tepung, dan biasanya ditemukan di bagian bawah permukaan daun dalam koloni atau cenderung berkelompok.",
      gallery: [],
      pesticides: [
        "Pestisida Nabati: Ekstrak kulit bawang merah dengan dosis larutan 300 ml per 15 liter air terbukti efektif membunuh hama kutu kebul pada tanaman cabai rawit.",
        "Pestisida Nabati: Ekstrak daun kemangi berfungsi efektif sebagai pengendali hama penghisap daun tanpa merugikan lingkungan sekitar.",
        "Pestisida Kimiawi: Direkomendasikan menggunakan insektisida sintetik berbahan aktif Imidakloprid atau Buprofezin dengan anjuran pengaplikasian disemprot pada permukaan bawah daun.",
      ],
      sources: [
        "Gambar: KlikHijau. Mengenal Kutu Kebul Hama Penyerang Tanaman.",
        "Sitorus, R. H., & Wilyus. Pengelolaan Hama Terpadu (PHT) Kutu Kebul, Kutu Daun (Aphids) dan Thrips pada Tanaman Cabai Keriting. Jurnal Media Pertanian (Jagro), 2023.",
        "Hasbulloh, M. I., Nirwanto, H., & Rahmadhini, N. Pendekatan Geostatistik Untuk Memetakan Sebaran Hama Kutu Kebul Pada Lahan Tanaman Melon. Jurnal HPT (Hama dan Penyakit Tumbuhan), 2025.",
      ],
    ),

    // ========================================================
    // 3. THRIPS (Thrips parvispinus)
    // ========================================================
    Pest(
      name: "Thrips",
      scientificName: "Thrips parvispinus",
      imagePath: "assets/images/thrips.jpg",
      description: "Thrips, terutama spesies Thrips parvispinus, merupakan hama penting pada tanaman cabai yang menyerang jaringan daun dan bunga. Gejala serangan berupa munculnya bercak keperakan pada permukaan daun, deformasi bunga, serta kerontokan bunga dan buah muda. Selain menimbulkan kerusakan langsung, thrips juga berperan sebagai vektor virus Tobacco Streak Virus (TSV). Serangan hama ini dapat menurunkan hasil panen hingga sekitar 23% apabila tidak dikendalikan secara efektif. Thrips memiliki tubuh kecil dan ramping, berwarna cokelat hingga hitam, serta bergerak cepat. Hama ini biasanya ditemukan tersembunyi di lipatan daun atau di sela-sela kelopak bunga.",
      gallery: [],
      pesticides: [
        "Pestisida Nabati: Ekstrak daun kemangi memberikan pengaruh signifikan untuk mengendalikan komoditas hama penghisap daun seperti thrips.",
        "Pestisida Kimiawi: Jika tingkat serangan tinggi, gunakan insektisida berbahan aktif Abamektin atau Spinosad. Lakukan rotasi bahan aktif secara berkala untuk mencegah timbulnya resistansi hama.",
      ],
      sources: [
        "Gambar: Infarm. Mengenal Hama Thrips dan Cara Pengendaliannya pada Tanaman Cabai.",
        "Sitorus, R. H., & Wilyus. Pengelolaan Hama Terpadu (PHT) Kutu Kebul, Kutu Daun (Aphids) dan Thrips pada Tanaman Cabai Keriting. Jurnal Media Pertanian (Jagro), 2023.",
      ],
    ),

    // ========================================================
    // 4. PENYAKIT ANTRAKNOSA (Suplemen Data Tambahan Buku TA)
    // ========================================================
    Pest(
      name: "Penyakit Antraknosa",
      scientificName: "Colletotrichum spp.",
      imagePath: "assets/images/antraknosa.jpg",
      description: "Meskipun merupakan infeksi jamur, tingkat keparahan antraknosa pada tanaman cabai sangat dipengaruhi oleh luka mekanis akibat tusukan vektor hama penghisap daun. Gejala ditandai dengan bercak melingkar busuk berair pada buah cabai (muda maupun tua) yang membuat komoditas menjadi kering, keriput, dan gugur sebelum dipanen.",
      gallery: [],
      pesticides: [
        "Pestisida Nabati: Aplikasi pestisida organik berbasis ekstrak daun bintaro dengan takaran larutan 30 ml per liter air terbukti secara signifikan mampu menekan penyebaran penyakit antraknosa.",
      ],
      sources: [
        "Rahmawati, S., Pramudi, M. I., & Liestiany, E. Pengaruh pemberian pestisida nabati daun bintaro terhadap penyakit antraknosa tanaman cabai. Jurnal Proteksi Tanaman Tropika, 2024.",
      ],
    ),
  ];
}