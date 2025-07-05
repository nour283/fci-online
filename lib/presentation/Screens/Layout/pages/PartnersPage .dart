import 'package:flutter/material.dart';

class PartnersPopup extends StatelessWidget {
  const PartnersPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double dialogWidth = 170;
    final double dialogHeight = screenSize.height < 600 ? screenSize.height * 0.8 : 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: (screenSize.width - dialogWidth) / 2,
        vertical: (screenSize.height - dialogHeight) / 2,
      ),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8E8E8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPartnerLogo('assets/images/cisco.png'),
                    const SizedBox(height: 25),
                    _buildPartnerLogo('assets/images/huawei.png'),
                    const SizedBox(height: 25),
                    _buildPartnerLogo('assets/images/microsoft.png'),
                    const SizedBox(height: 25),
                    _buildPartnerLogo('assets/images/iti.png'),
                    const SizedBox(height: 25),
                    _buildPartnerLogo('assets/images/intel.png'),
                    const SizedBox(height: 25),
                    _buildPartnerLogo('assets/images/googl.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerLogo(String assetPath) {
    return LayoutBuilder(
      builder: (context, constraints) {
        
        double logoSize = constraints.maxWidth * 0.93;
        return Image.asset(
          assetPath,
          height: 60,
          width: logoSize,
          fit: BoxFit.contain,
         
        );
      },
    );
  }
}
