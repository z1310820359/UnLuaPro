// Fill out your copyright notice in the Description page of Project Settings.


#include "Service/LuaGameInstanceService.h"

bool ULuaGameInstanceService::ShouldCreateSubsystem(UObject* Outer) const
{
	return true;
}

void ULuaGameInstanceService::Initialize(FSubsystemCollectionBase& Collection)
{
	Super::Initialize(Collection);
	LuaInit();
}

void ULuaGameInstanceService::Deinitialize()
{
	LuaDeinit();
	Super::Deinitialize();
}
