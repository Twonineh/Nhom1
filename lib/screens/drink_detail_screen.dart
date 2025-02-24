import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/drink.dart';
import '../models/cart_item.dart';
import '../screens/cart_screen.dart';

class DrinkDetailScreen extends StatefulWidget {
  final Drink drink;
  final Function(Drink, int, String) onAddToCart;
  final List<CartItem> cartItems;
  final Function(Drink, int, String) onUpdateQuantity;
  final VoidCallback onRemoveItem;

  const DrinkDetailScreen({
    Key? key,
    required this.drink,
    required this.onAddToCart,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  State<DrinkDetailScreen> createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen> {
  String _selectedSize = 'M';
  int _rating = 4;
  final GlobalKey _textContainerKey = GlobalKey();
  double _textContainerHeight = 0.0;
  double _imageAspectRatio = 3 / 4; // Default aspect ratio, adjust if needed


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _calculateTextContainerHeight();
        _loadImageAspectRatio();

    });
  }

  void _calculateTextContainerHeight() {
    if (_textContainerKey.currentContext != null) {
      final RenderBox? textRenderBox =
          _textContainerKey.currentContext!.findRenderObject() as RenderBox?;
      if (textRenderBox != null) {
        setState(() {
          _textContainerHeight = textRenderBox.size.height;
        });
      }
    }
  }

  // New method to get the image's aspect ratio
    void _loadImageAspectRatio() {
    if (widget.drink.imageUrl.isNotEmpty) { // Check if imageUrl exists
      Image image = Image.network(widget.drink.imageUrl);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            if (mounted) { // Check if the widget is still mounted
              setState(() {
                _imageAspectRatio = info.image.width / info.image.height;
              });
            }
          },
          onError: (dynamic exception, StackTrace? stackTrace) { // Add onError handler.
                print('Error loading image aspect ratio: $exception');
            },
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant DrinkDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.drink != oldWidget.drink) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _calculateTextContainerHeight();
        _loadImageAspectRatio(); // Reload aspect ratio on drink change
      });
    }
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: LayoutBuilder( // Use LayoutBuilder
          builder: (context, constraints) {
            return Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      key: _textContainerKey,
                      child: _buildDetailsContent(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30)),
                    child: Container(
                      // height: _textContainerHeight,  // Remove fixed height
                      // Use AspectRatio with the *calculated* aspect ratio
                      child: AspectRatio(
                        aspectRatio: _imageAspectRatio,
                        child: Image.network(
                            widget.drink.imageUrl,
                            fit: BoxFit.contain, // Use BoxFit.contain
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                    ),
                                );
                              },
                            errorBuilder: (context, object, stackTrace) {
                              return const Center(child: Icon(Icons.error, color: Colors.red));
                             },
                          ),
                        ),
                      ),
                   ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.drink.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Smaller font
            overflow: TextOverflow.clip,
            maxLines: 2,
          ),
          const SizedBox(height: 8), // Smaller spacing
          Text(
            widget.drink.description,
            style: TextStyle(fontSize: 13, height: 1.3, color: Colors.grey[700]), // Smaller font
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          const SizedBox(height: 12), // Smaller spacing
          _buildRatingRow(),
          const SizedBox(height: 16), // Smaller spacing
          const Text(
            'Chọn Size',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Smaller font
          ),
          const SizedBox(height: 6), // Smaller spacing
          Row(
            children: [
              _buildSizeOption('S'),
              const SizedBox(width: 8),
              _buildSizeOption('M'),
              const SizedBox(width: 8),
              _buildSizeOption('L'),
            ],
          ),
          const SizedBox(height: 12), // Smaller spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoColumn(Icons.local_cafe, 'PREP', '5 min'),
              _buildInfoColumn(Icons.timer, 'SIZE', _selectedSize),
              _buildInfoColumn(
                Icons.attach_money,
                'PRICE',
                '${widget.drink.getPriceForSize(_selectedSize).toStringAsFixed(0)}',
              ),
            ],
          ),
          const SizedBox(height: 12), // Smaller spacing
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 10), // Smaller padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              widget.onAddToCart(widget.drink, 1, _selectedSize);
            },
            child: const Center(
              child: Text(
                'Thêm vào giỏ hàng',
                style: TextStyle(fontSize: 14, color: Colors.white), // Smaller font
              ),
            ),
          ),
           const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
  return Row(
    children: [
      FittedBox(
        child: Row(
          children: List.generate(5, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _rating = index + 1;
                  _calculateTextContainerHeight(); //Recalculate.
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0), // Smaller padding
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20, // Smaller size
                ),
              ),
            );
          }),
        ),
      ),
      const SizedBox(width: 6), // Smaller spacing
      Text(
        '($_rating/5)',
        style: TextStyle(color: Colors.grey[600], fontSize: 12), // Smaller font
      ),
    ],
  );
}

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 20), // Smaller size
        const SizedBox(height: 3), // Smaller spacing
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 11, // Smaller font
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3), // Smaller spacing
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), // Smaller font
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSize = size;
          _calculateTextContainerHeight(); // Recalculate height on size change
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
        decoration: BoxDecoration(
          color: _selectedSize == size ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: _selectedSize == size ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11, // Smaller font
            ),
          ),
        ),
      ),
    );
  }
}