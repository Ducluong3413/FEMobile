// import 'package:flutter/material.dart';

// class FirstAidStrokePage extends StatelessWidget {
//   const FirstAidStrokePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Hướng Dẫn Sơ Cứu',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Phương Pháp Đột Quỵ Cần Nằm Vững',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             _buildStep(
//               'Bước 1',
//               'Giữ bình tĩnh và đặt người bệnh nằm nghiêng:\n'
//                   'Giữ người bệnh nằm nghiêng để tránh nguy cơ hít phải dị vật hoặc dịch tiết vào đường thở nếu người bệnh nôn mửa. Tư thế nằm nghiêng cũng giúp giảm áp lực lên đường thở làm thông thoáng đường thở bằng cách lau sạch đờm dãi nếu có.',
//             ),
//             _buildStep(
//               'Bước 2',
//               'Gọi cấp cứu:\n'
//                   'Đây là bước quan trọng nhất trong đột quỵ tại nhà. Gọi cấp cứu ngay lập tức để đưa người bệnh đến cơ sở y tế gần nhất. Hãy báo cho nhân viên y tế biết các triệu chứng người bệnh đang gặp phải để họ có thể chuẩn bị sẵn sàng.',
//             ),
//             _buildStep(
//               'Bước 3',
//               'Không để người bệnh cử động mạnh:\n'
//                   'Không nên di chuyển người bệnh quá nhiều, và đặc biệt không nên để họ tự mình di lại. Động tác mạnh có thể khiến máu lưu thông nhanh hơn, làm tăng áp lực lên não và khiến tình trạng tồi tệ hơn.',
//             ),
//             _buildStep(
//               'Bước 4',
//               'Hỗ trợ hô hấp nếu cần thiết, ngưng thở:\n'
//                   'Kiểm tra tim mạch, huyết áp, nhịp thở.\n'
//                   '- Huyết áp: Nếu bạn có máy đo huyết áp tại nhà, hãy kiểm tra huyết áp của người bệnh. Tuy nhiên, không tự ý dùng thuốc hạ huyết áp nếu không có chỉ định từ bác sĩ.\n'
//                   '- Nhịp thở: Hãy theo dõi nhịp thở của bệnh nhân và đảm bảo họ thở được dễ dàng.',
//             ),
//             _buildStep(
//               'Bước 5',
//               'Giữ người bệnh ở trong tình trạng ấm áp:\n'
//                   'Giữ thân nhiệt ổn định bằng cách đắp chăn mỏng.\n'
//                   'Lưu ý không nên sử dụng quá nhiều chăn hoặc đắp chăn dày vì có thể gây cản trở hô hấp.',
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Videos: Kỹ Năng Sơ Cứu Người Bệnh Đột Quỵ',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             // ClipRRect(
//             //   borderRadius: BorderRadius.circular(8),
//             //   child: Image.asset('assets/stroke_first_aid_video_thumbnail.png'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStep(String title, String content) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: RichText(
//         text: TextSpan(
//           style: const TextStyle(color: Colors.black, fontSize: 16),
//           children: [
//             TextSpan(
//               text: '$title: ',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextSpan(text: content),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FirstAidStrokePage extends StatefulWidget {
  const FirstAidStrokePage({super.key});

  @override
  _FirstAidStrokePageState createState() => _FirstAidStrokePageState();
}

class _FirstAidStrokePageState extends State<FirstAidStrokePage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    // Thay thế URL này bằng link video của bạn
    _controller =
        _controller = VideoPlayerController.asset(
            'assets/video/video_so_cuu.mp4',
          )
          ..initialize().then((_) {
            setState(() {
              _isVideoInitialized = true;
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hướng Dẫn Sơ Cứu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phương Pháp Đột Quỵ Cần Nằm Vững',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStep(
              'Bước 1',
              'Giữ bình tĩnh và đặt người bệnh nằm nghiêng:\n'
                  'Giữ người bệnh nằm nghiêng để tránh nguy cơ hít phải dị vật hoặc dịch tiết vào đường thở nếu người bệnh nôn mửa. Tư thế nằm nghiêng cũng giúp giảm áp lực lên đường thở làm thông thoáng đường thở bằng cách lau sạch đờm dãi nếu có.',
            ),
            _buildStep(
              'Bước 2',
              'Gọi cấp cứu:\n'
                  'Đây là bước quan trọng nhất trong đột quỵ tại nhà. Gọi cấp cứu ngay lập tức để đưa người bệnh đến cơ sở y tế gần nhất. Hãy báo cho nhân viên y tế biết các triệu chứng người bệnh đang gặp phải để họ có thể chuẩn bị sẵn sàng.',
            ),
            _buildStep(
              'Bước 3',
              'Không để người bệnh cử động mạnh:\n'
                  'Không nên di chuyển người bệnh quá nhiều, và đặc biệt không nên để họ tự mình di lại. Động tác mạnh có thể khiến máu lưu thông nhanh hơn, làm tăng áp lực lên não và khiến tình trạng tồi tệ hơn.',
            ),
            _buildStep(
              'Bước 4',
              'Hỗ trợ hô hấp nếu cần thiết, ngưng thở:\n'
                  'Kiểm tra tim mạch, huyết áp, nhịp thở.\n'
                  '- Huyết áp: Nếu bạn có máy đo huyết áp tại nhà, hãy kiểm tra huyết áp của người bệnh. Tuy nhiên, không tự ý dùng thuốc hạ huyết áp nếu không có chỉ định từ bác sĩ.\n'
                  '- Nhịp thở: Hãy theo dõi nhịp thở của bệnh nhân và đảm bảo họ thở được dễ dàng.',
            ),
            _buildStep(
              'Bước 5',
              'Giữ người bệnh ở trong tình trạng ấm áp:\n'
                  'Giữ thân nhiệt ổn định bằng cách đắp chăn mỏng.\n'
                  'Lưu ý không nên sử dụng quá nhiều chăn hoặc đắp chăn dày vì có thể gây cản trở hô hấp.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Videos: Kỹ Năng Sơ Cứu Người Bệnh Đột Quỵ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _isVideoInitialized
                ? Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                )
                : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: content),
          ],
        ),
      ),
    );
  }
}
