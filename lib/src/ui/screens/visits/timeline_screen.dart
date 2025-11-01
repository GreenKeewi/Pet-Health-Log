import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/visit.dart';
import '../../../models/pet.dart';
import '../../../services/supabase_service.dart';

class TimelineScreen extends StatefulWidget {
  final Pet pet;

  const TimelineScreen({super.key, required this.pet});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _supabaseService = SupabaseService();
  List<Visit> _visits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    setState(() => _isLoading = true);

    try {
      final visits = await _supabaseService.getVisits(widget.pet.id);
      setState(() {
        _visits = visits;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading visits: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, List<Visit>> _groupVisitsByMonth() {
    final grouped = <String, List<Visit>>{};
    for (final visit in _visits) {
      if (visit.visitDate != null) {
        final key = DateFormat('MMMM yyyy').format(visit.visitDate!);
        grouped.putIfAbsent(key, () => []).add(visit);
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pet.name}\'s Timeline'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _visits.isEmpty
              ? _buildEmptyState()
              : _buildTimeline(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add visit screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No visits yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Start tracking ${widget.pet.name}\'s health by adding the first visit',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to add visit
              },
              icon: const Icon(Icons.add),
              label: const Text('Add First Visit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final groupedVisits = _groupVisitsByMonth();
    final sortedKeys = groupedVisits.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA); // Newest first
      });

    return RefreshIndicator(
      onRefresh: _loadVisits,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          final monthKey = sortedKeys[index];
          final visits = groupedVisits[monthKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  monthKey,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...visits.map((visit) => _buildVisitCard(visit)),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVisitCard(Visit visit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to visit detail
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getVisitIcon(visit.visitType),
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visit.clinicName ?? 'Visit',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (visit.visitDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, y').format(visit.visitDate!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (visit.totalCost != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${visit.totalCost!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
              if (visit.visitType != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getVisitTypeColor(visit.visitType!).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    visit.visitType!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getVisitTypeColor(visit.visitType!),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
              if (visit.aiSummary != null && visit.aiSummary!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  visit.aiSummary!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getVisitIcon(String? visitType) {
    switch (visitType) {
      case 'checkup':
        return Icons.health_and_safety;
      case 'vaccine':
        return Icons.vaccines;
      case 'dental':
        return Icons.local_hospital;
      case 'emergency':
        return Icons.emergency;
      case 'grooming':
        return Icons.content_cut;
      default:
        return Icons.medical_services;
    }
  }

  Color _getVisitTypeColor(String visitType) {
    switch (visitType) {
      case 'checkup':
        return Colors.blue;
      case 'vaccine':
        return Colors.green;
      case 'dental':
        return Colors.purple;
      case 'emergency':
        return Colors.red;
      case 'grooming':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
