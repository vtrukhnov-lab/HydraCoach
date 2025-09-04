import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';

/// Простая звездочка PRO badge для отображения рядом с заблокированными разделами
class ProBadge extends StatelessWidget {
  final bool showAlways; // Показывать всегда или только для FREE пользователей
  final double size;
  final bool interactive; // Можно ли нажать для открытия пейвола
  
  const ProBadge({
    Key? key,
    this.showAlways = false,
    this.size = 16,
    this.interactive = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final isPro = subscriptionProvider.isPro;
        
        // Если пользователь PRO и не нужно показывать всегда - скрываем
        if (isPro && !showAlways) {
          return const SizedBox.shrink();
        }
        
        // Определяем цвет звездочки
        final color = isPro 
          ? Colors.amber // Золотая для PRO пользователей
          : Colors.grey.shade400; // Серая для FREE пользователей
        
        Widget badge = Icon(
          Icons.star,
          size: size,
          color: color,
        );
        
        // Если интерактивная и пользователь FREE - добавляем возможность нажатия
        if (interactive && !isPro) {
          badge = GestureDetector(
            onTap: () => _showPaywall(context),
            child: badge,
          );
        }
        
        return badge;
      },
    );
  }
  
  void _showPaywall(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    );
  }
}

/// Обёртка для элементов списка с PRO функциями
class ProListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leading;
  final VoidCallback? onTap;
  final bool isPro; // Является ли эта функция PRO
  
  const ProListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.isPro = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final hasAccess = !isPro || subscriptionProvider.isPro;
        
        return ListTile(
          leading: leading != null 
            ? Icon(
                leading,
                color: hasAccess ? null : Colors.grey.shade400,
              )
            : null,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: hasAccess ? null : Colors.grey.shade600,
                  ),
                ),
              ),
              if (isPro) ...[
                const SizedBox(width: 8),
                ProBadge(size: 16, interactive: !hasAccess),
              ],
            ],
          ),
          subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: hasAccess 
                    ? Theme.of(context).textTheme.bodySmall?.color 
                    : Colors.grey.shade400,
                ),
              )
            : null,
          onTap: () {
            if (hasAccess && onTap != null) {
              onTap!();
            } else if (!hasAccess) {
              _showPaywall(context);
            }
          },
          enabled: hasAccess,
        );
      },
    );
  }
  
  void _showPaywall(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    );
  }
}

/// Кнопка с PRO badge
class ProButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPro;
  final IconData? icon;
  final ButtonStyle? style;
  
  const ProButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPro = false,
    this.icon,
    this.style,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final hasAccess = !isPro || subscriptionProvider.isPro;
        
        return ElevatedButton(
          onPressed: () {
            if (hasAccess && onPressed != null) {
              onPressed!();
            } else if (!hasAccess) {
              _showPaywall(context);
            }
          },
          style: style ?? ElevatedButton.styleFrom(
            backgroundColor: hasAccess ? null : Colors.grey.shade300,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(text),
              if (isPro) ...[
                const SizedBox(width: 8),
                ProBadge(size: 14, interactive: false),
              ],
            ],
          ),
        );
      },
    );
  }
  
  void _showPaywall(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    );
  }
}

/// Карточка с PRO функцией
class ProCard extends StatelessWidget {
  final Widget child;
  final bool isPro;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const ProCard({
    Key? key,
    required this.child,
    this.isPro = false,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final hasAccess = !isPro || subscriptionProvider.isPro;
        
        return Card(
          margin: margin,
          child: InkWell(
            onTap: () {
              if (hasAccess && onTap != null) {
                onTap!();
              } else if (!hasAccess) {
                _showPaywall(context);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Opacity(
                  opacity: hasAccess ? 1.0 : 0.6,
                  child: AbsorbPointer(
                    absorbing: !hasAccess,
                    child: child,
                  ),
                ),
                if (isPro)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ProBadge(
                      size: 20,
                      interactive: !hasAccess,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showPaywall(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    );
  }
}