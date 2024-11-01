//
//  MovieDownloader.swift
//  Labo2
//
//  Created by Gabriel Poirier (Étudiant) on 2024-10-31.
//

import Foundation
let apiKey = "b2e66565"
var randomMovieTitle: String? // Variable globale pour stocker le titre du film


func fetchRandomID() -> String{
    if let randomID = listeFilms.randomElement() {
        print("ID de film aléatoire : \(randomID)")
        return randomID
    } else {
        print("La liste de films est vide.")
        return ""
    }
}
func fetchMovieTitle(withID movieID: String) {
    // Créer l'URL avec l'ID de film et la clé API
    guard let url = URL(string: "https://www.omdbapi.com/?i=\(movieID)&apikey=\(apiKey)") else {
        print("URL invalide.")
        return
    }
    
    // Créer une tâche de session URL pour récupérer les données
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Gestion des erreurs
        if let error = error {
            print("Erreur : \(error.localizedDescription)")
            return
        }
        
        // Vérifier la réponse et les données
        guard let data = data else {
            print("Aucune donnée reçue.")
            return
        }
        
        // Analyser les données JSON pour récupérer le titre
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let title = json["Title"] as? String {
                print("Titre du film : \(title)")
                randomMovieTitle = title // Stocker le titre dans une variable globale
            } else {
                print("Le format de réponse est inattendu.")
            }
        } catch {
            print("Erreur lors de l'analyse JSON : \(error.localizedDescription)")
        }
    }
    
    // Démarrer la requête
    task.resume()
}

// Fonction pour récupérer un ID de film aléatoire et chercher son titre
func fetchRandomMovieTitle(completion: @escaping (String) -> Void) {
    // Assume you have a random movie ID
    let randomID = fetchRandomID()  // Replace this with your logic to fetch a random ID
    
    // Create the URL with the ID
    guard let url = URL(string: "https://www.omdbapi.com/?i=\(randomID)&apikey=\(apiKey)") else {
        print("Invalid URL")
        return
    }
    
    // Perform the network request
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Handle errors
        if let error = error {
            print("Error fetching movie title: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        // Parse the JSON response
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let title = json["Title"] as? String {
                print(title)
                // Call the completion handler with the fetched title
                completion(title)
            } else {
                print("Unexpected JSON format")
            }
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
        }
    }
    
    task.resume()
}

