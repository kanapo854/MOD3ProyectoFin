import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final double price;
  final int stock;
  final String estado;
  final DateTime createdAt;
  final String categoria;

  Book({required this.id, required this.title, required this.author, required this.price, required this.stock, required this.estado, required this.createdAt, required this.categoria});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'price': price,
      'stock': stock,
      'estado': estado,
      'createdAt': createdAt.toIso8601String(),
      'categoria': categoria
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'],
      author: map['author'],
      price: map['price'],
      stock: map['stock'],
      estado: map['estado'],
      //createdAt: DateTime.parse(map['createdAt']),
      createdAt: map['createdAt'] is Timestamp 
      ? (map['createdAt'] as Timestamp).toDate()
      : DateTime.parse(map['createdAt']),
      categoria: map['categoria']
    );
  }
}
