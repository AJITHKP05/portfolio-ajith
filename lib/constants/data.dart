import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'colors.dart';

class Experience {
  final String role;
  final String company;
  final String duration;
  final String summary;
  final List<String> highlights;
  final List<String> tags;
  final Color accent;
  final List<String> projects;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.summary,
    required this.highlights,
    required this.tags,
    required this.accent,
    this.projects = const [],
  });

  String get initials => company
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0])
      .join()
      .toUpperCase();
}

class Project {
  final String name;
  final String tagline;
  final String domain;
  final String year;
  final List<String> stack;
  final List<String> highlights;
  final String metric;
  final String metricLabel;
  final FaIconData icon;
  final List<Color> colors;

  const Project({
    required this.name,
    required this.tagline,
    required this.domain,
    required this.year,
    required this.stack,
    required this.highlights,
    required this.metric,
    required this.metricLabel,
    required this.icon,
    required this.colors,
  });
}

class Certificate {
  final String title;
  final String type;
  final String issuer;
  final String date;
  final String venue;
  final String description;
  final String image;
  final double aspectRatio;

  const Certificate({
    required this.title,
    required this.type,
    required this.issuer,
    required this.date,
    required this.venue,
    required this.description,
    required this.image,
    required this.aspectRatio,
  });
}

class SkillGroup {
  final String title;
  final FaIconData icon;
  final List<String> items;

  const SkillGroup(this.title, this.icon, this.items);
}

class Stat {
  final int value;
  final String suffix;
  final String label;

  const Stat(this.value, this.suffix, this.label);
}

class PortfolioData {
  static const String name = "AJITH KP";
  static const String firstName = "Ajith";
  static const String title =
      "Senior Software Engineer · Flutter & Mobile Specialist";
  static const String location = "Bengaluru, India";
  static const String experienceYears = "6+";

  static const List<String> roles = [
    "Senior Flutter Engineer",
    "Mobile App Architect",
    "Fintech App Specialist",
    "Android & iOS Developer",
  ];

  static const String tagline =
      "I design, build and ship production-grade mobile apps for Fintech, Education and E-commerce — from secure banking platforms to dual-sided commerce ecosystems.";

  static const String bio =
      "Senior Software Engineer with $experienceYears years of expertise building production-grade Flutter applications across Fintech, Education, and E-commerce domains. Proven track record architecting scalable mobile and web solutions — from secure banking platforms and Demat/SIP investment journeys to dual-sided e-commerce ecosystems.";

  static const String bio2 =
      "Strong command of Dart, Kotlin, and BLoC/MVP patterns, with hands-on experience integrating REST APIs, Firebase, Google Maps, and third-party payment systems. Shipped apps on both Android and iOS with measurable performance improvements including 40% crash reduction and 25% faster order processing. Alongside full-time roles, I take on freelance projects — helping startups and businesses turn ideas into polished, store-ready apps.";

  static const String email = "ajithkp1537@gmail.com";
  static const String phone = "+91 9496089097";
  static const String linkedin = "https://www.linkedin.com/in/ajith-kp-a4b483a1";
  static const String github = "https://www.github.com/ajithkp05";
  static const String resumeAsset = "assets/Resume_AJITH.pdf";

  static const String education =
      "B.Tech — Electronics & Telecommunication Engineering";
  static const String educationDetail = "Calicut University · 2018";

  static const List<Stat> stats = [
    Stat(6, "+", "Years of experience"),
    Stat(8, "+", "Production apps shipped"),
    Stat(4, "", "Companies"),
    Stat(40, "%", "Crash rate reduction"),
  ];

  static const List<SkillGroup> skillGroups = [
    SkillGroup("Languages", FontAwesomeIcons.code, [
      "Dart",
      "Kotlin",
      "Swift",
      "Java",
    ]),
    SkillGroup("Frameworks", FontAwesomeIcons.layerGroup, [
      "Flutter",
      "Jetpack Compose",
      "Spring Boot",
    ]),
    SkillGroup("State Management", FontAwesomeIcons.diagramProject, [
      "BLoC",
      "Provider",
      "Riverpod",
      "GetX",
      "MVP",
      "Clean Architecture",
    ]),
    SkillGroup("Backend / APIs", FontAwesomeIcons.server, [
      "REST APIs",
      "Firebase Auth",
      "Firestore",
      "FCM",
      "Analytics",
      "Google Maps SDK",
    ]),
    SkillGroup("DevOps / CI", FontAwesomeIcons.rocket, [
      "GitHub Actions",
      "App Store Connect",
      "Google Play Console",
    ]),
    SkillGroup("Testing", FontAwesomeIcons.vial, [
      "Unit",
      "Widget",
      "Integration",
      "Flutter Test",
    ]),
    SkillGroup("Dev Tools", FontAwesomeIcons.screwdriverWrench, [
      "Git",
      "GitHub",
      "Android Studio",
      "Xcode",
      "VS Code",
      "Postman",
    ]),
    SkillGroup("Platforms", FontAwesomeIcons.mobileScreen, [
      "Android",
      "iOS",
      "Flutter Web",
    ]),
  ];

  static const List<String> marquee = [
    "Flutter",
    "Dart",
    "Kotlin",
    "Swift",
    "Jetpack Compose",
    "BLoC",
    "Riverpod",
    "Firebase",
    "REST APIs",
    "Google Maps SDK",
    "GitHub Actions",
    "Spring Boot",
    "Android",
    "iOS",
    "Flutter Web",
  ];

  static const List<Experience> experience = [
    Experience(
      role: "Freelance Mobile Developer",
      company: "Self-employed",
      duration: "Ongoing · Remote",
      summary:
          "Independent Flutter work for startups and small businesses — idea to App Store.",
      highlights: [
        "Partnering directly with founders and businesses to design, build and launch cross-platform apps for Android, iOS and Web.",
        "Owning the full lifecycle — requirements, UI, architecture, API / Firebase integration, store release and post-launch support.",
      ],
      tags: ["Freelance", "Remote", "Flutter", "End-to-end"],
      projects: [
        "SocialMedia",
        "Stock Manager",
        "Clinic Webpage",
        "Sales App",
        "Media App",
        "Fitness App",
      ],
      accent: AppColors.green,
    ),
    Experience(
      role: "Senior Software Engineer",
      company: "Mphasis",
      duration: "May 2024 – Apr 2026",
      summary:
          "Enterprise Fintech delivery — banking & investment apps for large financial clients.",
      highlights: [
        "Leading Flutter development for enterprise-grade Fintech clients, owning full-cycle delivery from architecture to Play Store / App Store release.",
        "Partnering with product and QA teams to define technical specifications and code review standards for a team of 4+ engineers.",
      ],
      tags: ["Fintech", "Banking", "Tech Lead", "Flutter"],
      accent: AppColors.primary,
    ),
    Experience(
      role: "Software Developer",
      company: "Innovature Software Labs",
      duration: "Feb 2022 – Mar 2024",
      summary:
          "Multi-product engineering across Education and Fintech verticals.",
      highlights: [
        "Built and maintained multiple Flutter applications across Education and Fintech verticals.",
        "Collaborated with cross-functional teams in an Agile environment from planning to release.",
      ],
      tags: ["EdTech", "Fintech", "Agile", "Flutter"],
      accent: AppColors.violet,
    ),
    Experience(
      role: "Junior Software Developer",
      company: "RGC Dynamics",
      duration: "Jun 2021 – Feb 2022",
      summary: "Hybrid assessment platform built on Flutter + Spring Boot.",
      highlights: [
        "Developed Zocratez, a hybrid assessment platform using Flutter and Spring Boot to evaluate English proficiency across vocabulary and comprehension modules.",
      ],
      tags: ["EdTech", "Flutter", "Spring Boot"],
      accent: AppColors.secondary,
    ),
    Experience(
      role: "Junior Software Developer",
      company: "Hamon Technologies",
      duration: "Oct 2020 – May 2021",
      summary: "E-commerce ecosystem for a UAE-based retail client.",
      highlights: [
        "Delivered Sidra Kart, a dual-application E-commerce ecosystem — customer-facing Flutter app and admin dashboard synced via REST APIs.",
      ],
      tags: ["E-commerce", "UAE Client", "REST APIs"],
      accent: AppColors.amber,
    ),
  ];

  static const List<String> projectDomains = [
    "All",
    "Fintech",
    "E-commerce",
    "EdTech",
    "Services",
    "Enterprise",
    "Freelance",
  ];

  static const List<Project> projects = [
    Project(
      name: "Bank Loan Application System",
      tagline: "Secure, multi-step loan origination for a banking client",
      domain: "Fintech",
      year: "2024",
      stack: ["Flutter", "BLoC", "REST APIs", "Biometrics"],
      highlights: [
        "Multi-step loan origination flow with complex API integration.",
        "Lazy loading, stream optimisation & memory-leak fixes.",
        "Biometric auth and end-to-end encrypted data handling per banking compliance.",
      ],
      metric: "40%",
      metricLabel: "faster runtime",
      icon: FontAwesomeIcons.buildingColumns,
      colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
    ),
    Project(
      name: "ABCD — Demat & SIP Investing",
      tagline: "End-to-end Demat account & Portfolio SIP journeys",
      domain: "Fintech",
      year: "2023",
      stack: ["Flutter", "BLoC", "REST APIs"],
      highlights: [
        "~30% faster screen loads via pagination & optimised BLoC transitions.",
        "Structured error-handling across async flows.",
      ],
      metric: "40%",
      metricLabel: "fewer crashes",
      icon: FontAwesomeIcons.chartLine,
      colors: [Color(0xFF10B981), Color(0xFF0EA5E9)],
    ),
    Project(
      name: "Sidra Kart — E-Commerce (UAE)",
      tagline: "Customer app + admin dashboard for a UAE retailer",
      domain: "E-commerce",
      year: "2021",
      stack: ["Flutter", "REST APIs"],
      highlights: [
        "Real-time inventory and order sync between front-end and back-end.",
        "Role-based access for listings, orders & delivery tracking.",
      ],
      metric: "2",
      metricLabel: "production apps",
      icon: FontAwesomeIcons.cartShopping,
      colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
    ),
    Project(
      name: "Fabricspa — Laundry Platform",
      tagline: "High-traffic order management for laundry services",
      domain: "Services",
      year: "2021",
      stack: ["Flutter", "Spring Boot"],
      highlights: [
        "Optimised API query design for order processing.",
        "Real-time order status for customers and service agents.",
      ],
      metric: "25%",
      metricLabel: "faster processing",
      icon: FontAwesomeIcons.shirt,
      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    ),
    Project(
      name: "Genskill — Placement Platform",
      tagline: "Tracking students from internship to job placement",
      domain: "EdTech",
      year: "2022",
      stack: ["Flutter", "Firestore", "FCM"],
      highlights: [
        "Placement pipelines, mock interview scheduling & course gap analysis.",
        "Firestore real-time sync and FCM push notifications.",
      ],
      metric: "Live",
      metricLabel: "real-time sync",
      icon: FontAwesomeIcons.graduationCap,
      colors: [Color(0xFF22D3EE), Color(0xFF8B5CF6)],
    ),
    Project(
      name: "Zocratez — English Assessment",
      tagline: "Hybrid proficiency assessment application",
      domain: "EdTech",
      year: "2022",
      stack: ["Flutter", "Spring Boot"],
      highlights: [
        "Evaluates vocabulary, comprehension and spoken English.",
      ],
      metric: "3",
      metricLabel: "assessment modules",
      icon: FontAwesomeIcons.language,
      colors: [Color(0xFFEC4899), Color(0xFFF97316)],
    ),
    Project(
      name: "ESquare — Repair Tracker",
      tagline: "Service-progress tracking for gadget repair",
      domain: "Services",
      year: "2021",
      stack: ["Flutter", "Spring Boot"],
      highlights: [
        "Live status updates from intake to completion.",
      ],
      metric: "Live",
      metricLabel: "status tracking",
      icon: FontAwesomeIcons.screwdriverWrench,
      colors: [Color(0xFF14B8A6), Color(0xFF22C55E)],
    ),
    Project(
      name: "Resource Manager",
      tagline: "Internal HR / ops allocation tool",
      domain: "Enterprise",
      year: "2022",
      stack: ["Native Android", "Jetpack Compose", "Kotlin"],
      highlights: [
        "Manages employee allocation across concurrent projects.",
        "Replaced a manual spreadsheet workflow.",
      ],
      metric: "0",
      metricLabel: "spreadsheets left",
      icon: FontAwesomeIcons.usersGear,
      colors: [Color(0xFF6366F1), Color(0xFF22D3EE)],
    ),
    Project(
      name: "SocialMedia",
      tagline: "Social communication app connecting users",
      domain: "Freelance",
      year: "",
      stack: ["Chat", "Voice Calls", "Video Calls"],
      highlights: [
        "Built for communication between users with real-time chat.",
        "One-to-one voice and video calling.",
      ],
      metric: "Live",
      metricLabel: "chat, voice & video",
      icon: FontAwesomeIcons.comments,
      colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
    ),
    Project(
      name: "Stock Manager",
      tagline: "Inventory & stock accounts with smart alerts",
      domain: "Freelance",
      year: "",
      stack: ["Inventory", "Alerts", "Analytics"],
      highlights: [
        "Manages stock accounts across products.",
        "Notifies when quantity is low or about to run out.",
        "Profit tracking and other sales analysis.",
      ],
      metric: "Smart",
      metricLabel: "low-stock alerts",
      icon: FontAwesomeIcons.boxesStacked,
      colors: [Color(0xFF10B981), Color(0xFFF59E0B)],
    ),
    Project(
      name: "Clinic Webpage",
      tagline: "Website for a clinic, its services and updates",
      domain: "Freelance",
      year: "",
      stack: ["Web", "Responsive"],
      highlights: [
        "Showcases the clinic's services for patients.",
        "Publishes the latest clinic updates and news.",
      ],
      metric: "Web",
      metricLabel: "services & updates",
      icon: FontAwesomeIcons.houseMedical,
      colors: [Color(0xFF0EA5E9), Color(0xFF10B981)],
    ),
    Project(
      name: "Sales App",
      tagline: "Product listings sold directly by the seller",
      domain: "Freelance",
      year: "",
      stack: ["Catalogue", "Direct Selling"],
      highlights: [
        "Sellers list their products in a browsable catalogue.",
        "Products are sold directly by the seller to buyers.",
      ],
      metric: "Direct",
      metricLabel: "seller to buyer",
      icon: FontAwesomeIcons.store,
      colors: [Color(0xFFF97316), Color(0xFFEC4899)],
    ),
    Project(
      name: "Media App",
      tagline: "Location-aware video, reels and ads",
      domain: "Freelance",
      year: "",
      stack: ["Video", "Reels", "Geo-targeting"],
      highlights: [
        "Users watch videos alongside related reels.",
        "Reels and ads are served based on the user's location.",
      ],
      metric: "Geo",
      metricLabel: "location-based feed",
      icon: FontAwesomeIcons.circlePlay,
      colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
    ),
    Project(
      name: "Fitness App",
      tagline: "Health data, workouts, steps and challenges",
      domain: "Freelance",
      year: "",
      stack: ["Health Data", "Step Tracking", "Video", "Challenges"],
      highlights: [
        "Handles users' health-related data in one place.",
        "Training videos for guided workouts.",
        "Step tracker and fitness challenges to keep users engaged.",
      ],
      metric: "Active",
      metricLabel: "steps & challenges",
      icon: FontAwesomeIcons.heartPulse,
      colors: [Color(0xFF22C55E), Color(0xFF22D3EE)],
    ),
  ];

  static const List<Certificate> certificates = [
    Certificate(
      title: "Google Cloud Community Day Kochi 2026",
      type: "Certificate of Participation",
      issuer: "Google Developer Groups Cloud Kochi",
      date: "14 Nov 2026",
      venue: "Holiday Inn, Kochi",
      description:
          "Recognised for active participation and contribution to the exchange of knowledge and ideas at Kerala's landmark Google Cloud community event.",
      image: "assets/certificates/gcloud_community_day_kochi_2026.png",
      aspectRatio: 1600 / 1132,
    ),
    Certificate(
      title: "Attention is All You Web",
      type: "Certificate of Participation",
      issuer: "GDG Cloud Kochi · Google Developer Groups",
      date: "12 Sep 2026",
      venue: "Kochi · 8 hours of professional development",
      description:
          "Attended and contributed to an 8-hour professional development event on the modern web, hosted by GDG Cloud Kochi.",
      image: "assets/certificates/attention_is_all_you_web_2026.png",
      aspectRatio: 1600 / 1236,
    ),
  ];
}
