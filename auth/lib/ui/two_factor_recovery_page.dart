import 'dart:ui';

import 'package:ente_auth/l10n/l10n.dart';
import 'package:ente_auth/services/user_service.dart';
import 'package:ente_auth/utils/dialog_util.dart';
import 'package:flutter/material.dart';

class TwoFactorRecoveryPage extends StatefulWidget {
  final String sessionID;
  final String encryptedSecret;
  final String secretDecryptionNonce;

  const TwoFactorRecoveryPage(
    this.sessionID,
    this.encryptedSecret,
    this.secretDecryptionNonce, {
    Key? key,
  }) : super(key: key);

  @override
  State<TwoFactorRecoveryPage> createState() => _TwoFactorRecoveryPageState();
}

class _TwoFactorRecoveryPageState extends State<TwoFactorRecoveryPage> {
  final _recoveryKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.recoverAccount,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: l10n.enterRecoveryKeyHint,
                contentPadding: const EdgeInsets.all(20),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              controller: _recoveryKey,
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(24)),
          Container(
            padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
            width: double.infinity,
            height: 64,
            child: OutlinedButton(
              onPressed: _recoveryKey.text.isNotEmpty
                  ? () async {
                      await UserService.instance.removeTwoFactor(
                        context,
                        widget.sessionID,
                        _recoveryKey.text,
                        widget.encryptedSecret,
                        widget.secretDecryptionNonce,
                      );
                    }
                  : null,
              child: Text(l10n.recover),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              showErrorDialog(
                context,
                l10n.contactSupport,
                l10n.contactSupportViaEmailMessage("support@ente.io"),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  l10n.noRecoveryKeyTitle,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
