import 'package:flutter/material.dart';

import '../models/converter_controller.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  late final ConverterController _controller;
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _controller = ConverterController();
    _inputController = TextEditingController(text: _controller.input);
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 36),
                    Text(
                      'Convert with ease.',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Quick, accurate conversions for everyday use.',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 30),
                    _buildCategorySelector(),
                    const SizedBox(height: 22),
                    _buildConversionCard(),
                    const SizedBox(height: 18),
                    _buildResultCard(),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Simple conversions. Clear answers.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9AA3B2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE2F4F0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: Color(0xFF168B75),
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'UNITLY',
          style: TextStyle(
            color: Color(0xFF17233F),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        const Icon(Icons.more_horiz_rounded, color: Color(0xFF68738A)),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: UnitCategory.values.map((category) {
          final selected = category == _controller.category;
          return Expanded(
            child: GestureDetector(
              onTap: () => _controller.setCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF17233F,
                            ).withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  category.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF17233F)
                        : const Color(0xFF7C8798),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConversionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2C46).withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputRow(),
          const SizedBox(height: 22),
          _buildUnitRow(
            label: 'FROM',
            unit: _controller.fromUnit,
            onChanged: _controller.setFromUnit,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const Expanded(child: Divider(color: Color(0xFFEEF0F4))),
                const SizedBox(width: 12),
                InkWell(
                  key: const ValueKey('swap-units'),
                  onTap: _controller.swapUnits,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F4F0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: Color(0xFF168B75),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Divider(color: Color(0xFFEEF0F4))),
              ],
            ),
          ),
          _buildUnitRow(
            label: 'TO',
            unit: _controller.toUnit,
            onChanged: _controller.setToUnit,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitRow({
    required String label,
    required Unit unit,
    required ValueChanged<Unit> onChanged,
  }) {
    final units = Unit.forCategory(_controller.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9AA3B2),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Unit>(
                  value: unit,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF7C8798),
                  ),
                  borderRadius: BorderRadius.circular(14),
                  items: units
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              color: Color(0xFF17233F),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onChanged(value);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              unit.symbol,
              style: const TextStyle(
                color: Color(0xFF9AA3B2),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VALUE',
          style: TextStyle(
            color: Color(0xFF9AA3B2),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('conversion-input'),
          controller: _inputController,
          onChanged: _controller.setInput,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          style: const TextStyle(
            color: Color(0xFF17233F),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: 'Enter a value',
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF17233F),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF67D6BD),
                size: 16,
              ),
              SizedBox(width: 7),
              Text(
                'RESULT',
                style: TextStyle(
                  color: Color(0xFFB7C2D3),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  _controller.formattedResult,
                  key: const ValueKey('conversion-result'),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _controller.toUnit.symbol,
                style: const TextStyle(
                  color: Color(0xFF67D6BD),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${_controller.input.isEmpty ? '0' : _controller.input} '
            '${_controller.fromUnit.label} = '
            '${_controller.formattedResult} ${_controller.toUnit.label}',
            style: const TextStyle(color: Color(0xFFB7C2D3), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
