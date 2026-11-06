import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryItem {
  final String label;
  final IconData icon;

  const CategoryItem({required this.label, required this.icon});
}

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<CategoryItem> categories = [
    CategoryItem(label: 'Facilities', icon: Icons.business_outlined),
    CategoryItem(label: 'Water', icon: Icons.water_drop_outlined),
    CategoryItem(label: 'Electricity', icon: Icons.bolt_outlined),
    CategoryItem(label: 'Safety', icon: Icons.shield_outlined),
    CategoryItem(label: 'Sanitation', icon: Icons.delete_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected =
              selectedCategory.toLowerCase() == cat.label.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onCategorySelected(cat.label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 92,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : const Color(0xFFD4E2D8),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                      size: 26,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
