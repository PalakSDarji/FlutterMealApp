import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/orders_provider.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,20,10),
              child: Container(
                height: min(widget.order.products.length * 20.0 + 10, 180),
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.order.products[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${product.title}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '${product.quantity}x \$${product.price}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
