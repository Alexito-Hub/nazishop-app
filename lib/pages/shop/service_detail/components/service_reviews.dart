import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/models/review_model.dart';
import '/components/app_dialog.dart';
import '/backend/review_service.dart';
import '/backend/order_service.dart';
import '/auth/firebase_auth/auth_util.dart';

class ServiceReviews extends StatefulWidget {
  final String serviceId;
  final Color primaryColor;

  const ServiceReviews({
    super.key,
    required this.serviceId,
    required this.primaryColor,
  });

  @override
  State<ServiceReviews> createState() => _ServiceReviewsState();
}

class _ServiceReviewsState extends State<ServiceReviews> {
  List<ReviewModel> _reviews = [];
  bool _isLoading = true;
  bool _canReview = false;
  String? _validOrderId;
  bool _alreadyReviewed = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // 1. Fetch Reviews
    final reviews = await ReviewService.getReviews(widget.serviceId);

    // 2. Check eligibility if logged in
    bool canReview = false;
    String? orderId;
    bool alreadyReviewed = false;

    if (currentUserUid.isNotEmpty) {
      // Check if I already reviewed
      alreadyReviewed = reviews.any((r) => r.userId == currentUserUid);

      if (!alreadyReviewed) {
        // Fetch my orders to see if I bought this service
        final orders = await OrderService.getMyOrders();

        for (var order in orders) {
          // Check if order contains this service
          if (order['listing'] != null &&
              order['listing']['serviceId'] == widget.serviceId) {
            canReview = true;
            orderId = order['_id'];
            break;
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _reviews = reviews;
        _canReview = canReview;
        _validOrderId = orderId;
        _alreadyReviewed = alreadyReviewed;
        _isLoading = false;
      });
    }
  }

  void _showReviewDialog() {
    final commentController = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          final theme = FlutterFlowTheme.of(context);
          return AppDialog(
            title: 'Escribir Reseña',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Califica este servicio',
                    style: GoogleFonts.outfit(color: theme.secondaryText)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: const Color(0xFFFFC107),
                        size: 32,
                      ),
                      onPressed: () {
                        setStateDialog(() => rating = index + 1.0);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Tu opinión (opcional)',
                    hintStyle: GoogleFonts.outfit(color: theme.secondaryText),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  style: GoogleFonts.outfit(color: theme.primaryText),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar',
                    style: GoogleFonts.outfit(color: theme.secondaryText)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  if (_validOrderId == null) return;

                  Navigator.pop(context); // Close dialog

                  final res = await ReviewService.createReview(
                    serviceId: widget.serviceId,
                    orderId: _validOrderId!,
                    rating: rating,
                    comment: commentController.text,
                  );

                  if (res['status'] == true) {
                    _loadData(); // Reload
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Reseña publicada!',
                                style: GoogleFonts.outfit(color: Colors.white)),
                            backgroundColor: widget.primaryColor),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(res['msg'] ?? 'Error',
                                style: GoogleFonts.outfit(color: Colors.white)),
                            backgroundColor: theme.error),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text('Publicar',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildStarRating(double rating, {double size = 16.0}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(Icons.star_rounded,
              color: const Color(0xFFFFC107), size: size);
        } else {
          return Icon(Icons.star_border_rounded,
              color: const Color(0xFFFFC107), size: size);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reseñas (${_reviews.length})',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            if (_canReview && !_alreadyReviewed)
              TextButton.icon(
                onPressed: _showReviewDialog,
                icon: Icon(Icons.edit, size: 16, color: widget.primaryColor),
                label: Text('Escribir Reseña',
                    style: GoogleFonts.outfit(color: widget.primaryColor)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No hay reseñas todavía. ¡Sé el primero!',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  widget.primaryColor.withOpacity(0.2),
                              backgroundImage: review.user?.photoURL != null
                                  ? NetworkImage(review.user!.photoURL!)
                                  : null,
                              child: review.user?.photoURL == null
                                  ? Text(
                                      (review.user?.displayName ?? 'U')[0]
                                          .toUpperCase(),
                                      style: GoogleFonts.outfit(
                                          color: widget.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.user?.displayName ?? 'Usuario',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _formatDate(review.createdAt),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildStarRating(review.rating),
                    if (review.comment.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        review.comment,
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
