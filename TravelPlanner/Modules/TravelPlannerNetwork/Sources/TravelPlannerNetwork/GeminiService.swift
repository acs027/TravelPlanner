//
//  GeminiService.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

// Network/GeminiService.swift

import Foundation
import FirebaseAI


public class GeminiService: @unchecked Sendable {
    
    // MARK: - Singleton
    
    public static let shared = GeminiService()
    
    
    // MARK: - Private Properties
    
    private let model: GenerativeModel
    private let ai: FirebaseAI
    
    // MARK: - Error Types
    
    enum AIServiceError: LocalizedError {
        case invalidResponse
        case networkError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid response from AI service"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Initializer
    
    private init() {
        // Define the structured JSON schema for aircraft data
        let locationSchema = Schema.object(
            properties: [
                "name": .string(),
                "type": .string(),
                "latitude": .double(),
                "longitude": .double(),
                "description": .string(),
                "symbol": .string()
            ]
        )
        
        // Schema for an array of aircraft
        let jsonSchema = Schema.array(items: locationSchema)
        
        // Initialize Firebase AI with Google AI backend
        self.ai = FirebaseAI.firebaseAI(backend: .googleAI())
        
        // Create GenerativeModel with JSON response configuration
        self.model = ai.generativeModel(
            modelName: "gemini-2.5-flash",
            generationConfig: GenerationConfig(
                responseMIMEType: "application/json",
                responseSchema: jsonSchema
            )
        )
    }
    
    // MARK: - Public Methods
    
    /// Generates aircraft identification content from an image
    /// - Parameter image: The image to analyze
    /// - Returns: JSON string containing aircraft data
    /// - Throws: AIServiceError if the operation fails
    func generateContent(location: String) async throws -> String {
        do {
            
            let prompt = createAnalysisPrompt(location: location)
            let response = try await model.generateContent(prompt)
            
            guard let json = response.text, !json.isEmpty else {
                throw AIServiceError.invalidResponse
            }
            
            print("AI Response: \(json)")
            return json
            
        } catch let error as AIServiceError {
            throw error
        } catch {
            throw AIServiceError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates the analysis prompt for aircraft identification
    /// - Returns: The formatted prompt string
    private func createAnalysisPrompt(location: String) -> String {
            """
            Location is \(location)

            You are assisting a travel app user by recommending specific travel locations such as famous landmarks, tourist attractions, or natural wonders — not general cities or countries.

            Based on the user's search term, respond with an **array of detailed and precise travel locations** using the following Swift data structure:

            struct TravelLocation: Decodable {
                let name: String
                let type: String // e.g., 'Monument', 'Beach', 'Museum', 'National Park'
                let latitude: Double
                let longitude: Double
                let description: String // a 1–2 sentence summary of why this place is notable or worth visiting
                let symbol: String // SF Symbol corresponding to it's type.
            }

            Guidelines:
            - Return **multiple** TravelLocation objects (not just one).
            - Do **not** include broad places like countries or large cities (e.g., "Italy", "New York").
            - Focus on specific attractions (e.g., "Eiffel Tower", "Statue of Liberty", "Plitvice Lakes National Park").
            - Coordinates must be **real and accurate**.
            - Descriptions should be informative but concise (1–2 sentences).
            - Ensure the results are relevant to the user's search and diverse in type if possible.

            """
    }
}


