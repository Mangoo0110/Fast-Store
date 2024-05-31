import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupTextEditWidget extends StatefulWidget {
  final String headerName;
  final String initialText;
  final Function(String text) onDone;
  const PopupTextEditWidget({super.key, required this.initialText, required this.onDone, required this.headerName});

  @override
  State<PopupTextEditWidget> createState() => _PopupTextEditWidgetState();
}

class _PopupTextEditWidgetState extends State<PopupTextEditWidget> {

  TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _controller.text = widget.initialText;
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoPageScaffold(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                  child: SizedBox(
                    height: 80,
                    width: constraints.maxWidth,
                    child: TextFormField(
                      onTap: () {
                        // _focusNode.requestFocus();
                    
                        // setState(() {
                          
                        // });
                      },
                      onTapOutside: (event){
                        _focusNode.unfocus();
                        setState(() {
                          
                        });
                      },
                      focusNode: _focusNode,
                      maxLines: 1,
                      controller: _controller,
                      showCursor: _focusNode.hasFocus,
                      style: AppTextStyle().normalSize(context: context),
                      decoration: InputDecoration(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        hintText: '',
                        labelText: widget.headerName,
                        labelStyle: AppTextStyle().greyBoldItalicNormalSize(context: context),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const UnderlineInputBorder(),
                        focusedBorder: const UnderlineInputBorder(),
                      ),
                      
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text('Cancel', style: AppTextStyle().greyBoldNormalSize(context: context),)
                                                        ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            widget.onDone(_controller.text);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.done_all, color: Colors.green,),
                                  Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text('Done', style: AppTextStyle().actionBoldNormalSize(context: context),)
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  
  }

}