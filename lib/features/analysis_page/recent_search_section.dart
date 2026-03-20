import 'package:flutter/material.dart';

class RecentSearchSection extends StatelessWidget {

  final List<String> searches;
  final void Function(String) onTap;

  const RecentSearchSection({
    super.key,
    required this.searches,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty){
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Searches",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 45,
           child: ShaderMask(
             shaderCallback: (Rect bounds){
               return const LinearGradient(
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
                 colors: [
                   Colors.transparent,
                   Colors.black,
                   Colors.black,
                   Colors.transparent
                 ],
                 stops: [0.0, 0.05, 0.95, 1.0]
               ).createShader(bounds);
             },
             blendMode: BlendMode.dst,
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               physics: BouncingScrollPhysics(),
               child: Row(
                 children: searches.map((name){
                   return Padding(
                     padding: const EdgeInsets.only(right: 12),
                     child: _buildChip(name),
                   );
                 }).toList(),
               ),
             ),
           ),
        )
      ],
    );
  }

  Widget _buildChip(String name){
    return GestureDetector(
      onTap: () => onTap(name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.1)
            )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history,
              size: 16,
              color: Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
