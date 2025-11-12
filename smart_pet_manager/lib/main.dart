import 'package:flutter/material.dart';

void main() => runApp(const SmartPetApp());

class SmartPetApp extends StatelessWidget {
  const SmartPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pet Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PetHomePage(),
    );
  }
}

/* =======================  OOP TARAFI  ======================= */

// Interface (Dart’ta abstract class ile ifade edilir)
abstract class Friendly {
  String greet(); // implement eden sınıflar davranışı tanımlar
}

// Mixin
mixin Flyable {
  String fly() => 'Flying high! 🕊️';
}

// Abstraction + Inheritance için taban sınıf
abstract class Pet {
  static int _count = 0;                     // static sayaç
  static int get totalPets => _count;

  final String name;

  // default constructor → static sayacı artırır
  Pet(this.name) {
    _count++;
  }

  // named constructor (ödev şartı)
  Pet.named({required this.name}) {
    _count++;
  }

  // abstract method (alt sınıflar implement eder)
  String makeSound();

  // super ile alt sınıflardan erişilsin diye küçük bir info
  String basicInfo() => '$runtimeType: $name';
}

// DOG
class Dog extends Pet implements Friendly {
  Dog(String name) : super(name);
  Dog.puppy({required String name}) : super.named(name: name); // named

  @override
  String makeSound() => 'Woof Woof!';

  @override
  String greet() => 'Wags tail happily 🐶';

  String whoAmI() => 'I am ${this.name} (Dog)'; // "this" kullanımı
}

// CAT
class Cat extends Pet implements Friendly {
  Cat(String name) : super(name);
  Cat.kitten({required String name}) : super.named(name: name); // named

  @override
  String makeSound() => 'Meow!';

  @override
  String greet() => 'Purrs softly 🐱';
}

// BIRD
class Bird extends Pet with Flyable implements Friendly {
  Bird(String name) : super(name);
  Bird.parrot({required String name}) : super.named(name: name); // named

  @override
  String makeSound() => 'Chirp Chirp!';

  @override
  String greet() => 'Tweets cheerfully 🐦';

  // super kullanımı (üst sınıf bilgisi)
  String details() => '(${super.basicInfo()}) — ${fly()}';
}

/* =======================  UI TARAFI  ======================= */

class PetHomePage extends StatelessWidget {
  const PetHomePage({super.key});

  // Örnek veri (3 farklı pet, named constructor’lar özellikle kullanıldı)
  List<Pet> buildPets() => <Pet>[
        Dog('Buddy'),
        Cat.kitten(name: 'Mia'),
        Bird.parrot(name: 'Tweety'),
      ];

  @override
  Widget build(BuildContext context) {
    // Not: hot-reload’da static sayaç tekrar artmasın isterseniz
    // üretimi State içinde yapabilirsiniz. Bu hali ödev için yeterli.
    final pets = buildPets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pet Manager'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pet = pets[index];
          final icon = switch (pet) {
            Dog _ => Icons.pets,
            Cat _ => Icons.pets_outlined,
            Bird _ => Icons.filter_hdr, // kuş simgesi benzeri
            _ => Icons.help_outline,
          };

          return Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(icon),
              ),
              title: Text('${pet.runtimeType}: ${pet.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(pet.makeSound()),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Total Pets: ${Pet.totalPets}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
