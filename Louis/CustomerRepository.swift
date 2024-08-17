//
//  CustomerRepository.swift
//  Louis
//
//  Created by Rudiney on 8/16/24.
//
 
import Foundation

protocol CustomerRepository {
    func create(_ user: Customer) async throws
    func deleteUser(for id: UUID) async throws
    func find(id: UUID) async throws -> Customer?
}
