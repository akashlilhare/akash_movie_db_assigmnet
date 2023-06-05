class TicketModel {
  TicketModel({
    required this.name,
    required this.email,
    required this.customerId,
    required this.movieId,
    required this.movieTitle,
    required this.ticketCount,
    required this.date,
    required this.timeSlot,
    required this.contactNo,
  });

  late final String name;
  late final String email;
  late final String customerId;
  late final String movieId;
  late final String movieTitle;
  late final int ticketCount;
  late final String date;
  late final String timeSlot;
  late final String contactNo;

  TicketModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    customerId = json['customer_id'];
    movieId = json['movie_id'];
    movieTitle = json['movie_title'];
    ticketCount = json['ticket_required'];
    date = json['date'];
    timeSlot = json['time_slot'];
    contactNo = json['contact_no'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['customer_id'] = customerId;
    _data['movie_id'] = movieId;
    _data['movie_title'] = movieTitle;
    _data['ticket_required'] = ticketCount;
    _data['date'] = date;
    _data['time_slot'] = timeSlot;
    _data['contact_no'] = contactNo;
    return _data;
  }
}
