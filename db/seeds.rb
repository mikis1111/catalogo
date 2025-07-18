# db/seeds.rb

Book.destroy_all

books = [
  {
    title: "Il nome della rosa",
    author: "Umberto Eco",
    publisher: "Bompiani",
    genre: "Storico",
    publication_year: 1980,
    isbn: "9788845247074",
    description: "Romanzo storico ambientato in un monastero medievale.",
    borrowed: false
  },
  {
    title: "1984",
    author: "George Orwell",
    publisher: "Mondadori",
    genre: "Distopico",
    publication_year: 1949,
    isbn: "9788804671638",
    description: "Classico distopico che racconta il regime del Grande Fratello.",
    borrowed: true
  },
  {
    title: "Il piccolo principe",
    author: "Antoine de Saint-Exupéry",
    publisher: "Repubblica",
    genre: "Fiaba",
    publication_year: 1943,
    isbn: "9788845292004",
    description: "Una fiaba poetica sull'amicizia e l'esistenza.",
    borrowed: false
  }
]

books.each do |attrs|
  Book.create!(attrs)
end

puts "✅ Seed completato: #{Book.count} libri creati."
